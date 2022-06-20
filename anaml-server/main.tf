terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name"       = "anaml-server"
    "app.kubernetes.io/version"    = var.anaml_server_version
    "app.kubernetes.io/component"  = "backend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_config_map" "anaml_server" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  data = {
    ANAML_POSTGRES_DATABASE_NAME   = var.anaml_database_schema_name
    ANAML_POSTGRES_DATABASE_SCHEMA = var.anaml_database_name
    ANAML_POSTGRES_HOST            = var.postgres_host
    ANAML_POSTGRES_PORT            = var.postgres_port
    ANAML_POSTGRES_USER            = var.postgres_user


    JAVA_OPTS = "-Dconfig.file=/config/application.conf -Dlog4j2.configurationFile=/config/log4j2.xml"

    "application.conf" = templatefile("${path.module}/_templates/application.conf", {
      anaml_external_domain   = var.hostname
      authentication_method   = var.authentication_method
      discovery_uri           = var.oidc_discovery_uri
      permitted_user_group_id = var.oidc_permitted_users_group_id
      additional_scopes       = var.oidc_additional_scopes
    })

    "log4j2.xml" = file("${path.module}/_templates/log4j2.xml")
  }
}

resource "kubernetes_deployment" "anaml_server" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  spec {
    replicas = var.kubernetes_deployment_replicas

    selector {
      match_labels = local.deployment_labels
    }

    template {
      metadata {
        labels = local.deployment_labels
      }

      spec {
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.anaml_server.metadata.0.name
          }
        }
        node_selector = {
          node_pool = var.kubernetes_deployment_node_pool
        }
        container {
          name              = var.kubernetes_deployment_name
          image             = "${var.container_registry}/anaml-server:${var.anaml_server_version}"
          image_pull_policy = var.kubernetes_image_pull_policy

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 15
            period_seconds        = 3
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }

          env_from {
            config_map_ref {
              name = "${var.kubernetes_deployment_name}"
            }
          }

          dynamic "env_from" {
            for_each = var.kubernetes_secret_refs
            content {
              secret_ref {
                name = env_from.value
              }
            }
          }

          args = [
            "--databaseServerName=$(ANAML_POSTGRES_HOST)",
            "--databasePortNumber=$(ANAML_POSTGRES_PORT)",
            "--databaseName=$(ANAML_POSTGRES_DATABASE_NAME)",
            "--databaseUser=$(ANAML_POSTGRES_USER)",
            "--databasePassword=${var.postgres_password}",
            "--databaseSchema=$(ANAML_POSTGRES_DATABASE_SCHEMA)",
          ]
        }
      }
    }
  }
}

# TODO: Do we want to do this (static NodePort) if it's generic? What is the alternative?
# resource "kubernetes_service" "anaml_server" {
#   metadata {
#     name        = var.kubernetes_deployment_name
#     namespace   = var.kubernetes_namespace
#     labels      = local.deployment_labels
#     annotations = var.kubernetes_service_annotations
#   }

#   spec {
#     type = "NodePort"
#     selector = {
#       "app.kubernetes.io/name" = "anaml-server"
#     }
#     port {
#       name        = "http"
#       port        = 8082
#       protocol    = "TCP"
#       target_port = 80
#     }
#   }
# }
