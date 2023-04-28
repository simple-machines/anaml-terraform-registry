/**
 * # anaml-pod-watcher Terraform module
 *
 * This module deploys a Kubernetes Deployment running the anaml-k8s-pod-watcher application.
 *
 * The anaml-k8s-pod-watcher app listens for Kubernetes Spark executor pods that fail and reports the failures back to anaml-server.
 * The results are shown on the Job Statistics page and are useful for debugging Job failures...did the job fail to a Kubernetes pod error, what is the pod name that failed so you can query the logs for further information.
 */

terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-pod-watcher"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.kubernetes_pod_watcher_version), ":", "_"),
      var.kubernetes_pod_watcher_version
    )
    "app.kubernetes.io/component"  = "backend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

}

resource "kubernetes_config_map" "kubernetes_pod_watcher" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_K8S_WATCHER_NAMESPACE             = var.kubernetes_namespace
    ANAML_K8S_WATCHER_POSTGRES_HOST         = var.postgres_host
    ANAML_K8S_WATCHER_POSTGRES_PORT         = var.postgres_port
    ANAML_K8S_WATCHER_POSTGRES_USER         = var.postgres_user
    ANAML_K8S_WATCHER_POSTGRES_PASSWORD     = "file:///var/secrets/anaml/ANAML_K8S_WATCHER_POSTGRES_PASSWORD"
    ANAML_K8S_WATCHER_POSTGRES_DATABASE     = var.anaml_database_name
    ANAML_K8S_WATCHER_ANAML_SERVER_URL      = var.anaml_server_url
    ANAML_K8S_WATCHER_ANAML_SERVER_USER     = var.anaml_server_username
    ANAML_K8S_WATCHER_ANAML_SERVER_PASSWORD = "file:///var/secrets/anaml/ANAML_K8S_WATCHER_ANAML_SERVER_PASSWORD"
  }
}

resource "kubernetes_secret" "anaml_server_password" {
  metadata {
    name      = "${var.kubernetes_deployment_name}-anaml-server-password"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_K8S_WATCHER_ANAML_SERVER_PASSWORD = var.anaml_server_password
  }
  type = "Opaque"
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "${var.kubernetes_deployment_name}-postgres-password"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_K8S_WATCHER_POSTGRES_PASSWORD = var.postgres_password
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "anaml_pod_watcher" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
      }
    }

    template {
      metadata {
        labels = local.deployment_labels
        annotations = {
          # Trigger POD restart on config/secret changes by hashing contents
          "checksum/configmap_${kubernetes_config_map.kubernetes_pod_watcher.metadata[0].name}" = sha256(jsonencode(kubernetes_config_map.kubernetes_pod_watcher.data))
          "checksum/secret_${kubernetes_secret.anaml_server_password.metadata[0].name}"         = sha256(jsonencode(kubernetes_secret.anaml_server_password.data))
          "checksum/secret_${kubernetes_secret.postgres_password.metadata[0].name}"             = sha256(jsonencode(kubernetes_secret.postgres_password.data))
        }
      }

      spec {
        service_account_name = var.kubernetes_service_account_name

        dynamic "security_context" {
          for_each = var.kubernetes_security_context != null ? [var.kubernetes_security_context] : []
          content {
            run_as_user  = security_context.value.run_as_user
            run_as_group = security_context.value.run_as_group
            fs_group     = security_context.value.fs_group
          }
        }

        volume {
          name = "anaml-server-password"
          secret {
            default_mode = "0444"
            secret_name  = kubernetes_secret.anaml_server_password.metadata.0.name
          }
        }

        volume {
          name = "postgres-password"
          secret {
            default_mode = "0444"
            secret_name  = kubernetes_secret.postgres_password.metadata.0.name
          }
        }

        node_selector = var.kubernetes_node_selector

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.kubernetes_pod_watcher_version))
            ? "${var.container_registry}/anaml-k8s-watcher@${var.kubernetes_pod_watcher_version}"
            : "${var.container_registry}/anaml-k8s-watcher:${var.kubernetes_pod_watcher_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.kubernetes_pod_watcher_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy


          volume_mount {
            name       = "anaml-server-password"
            mount_path = "/var/secrets/anaml/ANAML_K8S_WATCHER_ANAML_SERVER_PASSWORD"
            sub_path   = "ANAML_K8S_WATCHER_ANAML_SERVER_PASSWORD"
            read_only  = true
          }

          volume_mount {
            name       = "postgres-password"
            mount_path = "/var/secrets/anaml/ANAML_K8S_WATCHER_POSTGRES_PASSWORD"
            sub_path   = "ANAML_K8S_WATCHER_POSTGRES_PASSWORD"
            read_only  = true
          }

          env_from {
            config_map_ref {
              name = var.kubernetes_deployment_name
            }
          }
        }

        # User provided sidecars i.e Google Cloud SQL Auth Proxy or Logging sidecars
        dynamic "container" {
          for_each = var.kubernetes_pod_sidecars == null ? [] : var.kubernetes_pod_sidecars

          content {
            name              = container.value.name
            image             = container.value.image
            image_pull_policy = container.value.image_pull_policy
            command           = container.value.command == null ? [] : container.value.command

            dynamic "env" {
              for_each = container.value.env == null ? [] : container.value.env
              content {
                name  = env.name
                value = env.value
              }
            }

            dynamic "env_from" {
              for_each = container.value.env_from == null ? [] : container.value.env_from
              content {
                dynamic "config_map_ref" {
                  for_each = env_from.value.config_map_ref == null ? [] : [env_from.value.config_map_ref]
                  content {
                    name = config_map_ref.name
                  }
                }

                dynamic "secret_ref" {
                  for_each = env_from.value.secret_ref == null ? [] : [env_from.value.secret_ref]
                  content {
                    name = secret_ref.name
                  }
                }
              }
            }

            dynamic "volume_mount" {
              for_each = container.value.volume_mount == null ? [] : container.value.volume_mount
              content {
                name       = volume_mount.name
                mount_path = volume_mount.mount_path
                read_only  = volume_mount.read_only
              }
            }

            dynamic "security_context" {
              for_each = container.value.security_context == null ? [] : [container.value.security_context]
              content {
                run_as_non_root = security_context.value.run_as_non_root
                run_as_group    = security_context.value.run_as_group
                run_as_user     = security_context.value.run_as_user
              }
            }

            dynamic "port" {
              for_each = container.value.port == null ? [] : [container.value.port]
              content {
                container_port = port.value.container_port
              }
            }

          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}
