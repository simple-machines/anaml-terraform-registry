/**
 * # app-server Terraform module
 *
 * This module deploys a Kubernetes Deployment and Service running the Anaml backend server application
 */

terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }

  experiments = [module_variable_optional_attrs]
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-server"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_server_version), ":", "_"),
      var.anaml_server_version
    )
    "app.kubernetes.io/component"  = "backend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_config_map" "anaml_server" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_POSTGRES_DATABASE_NAME   = var.anaml_database_name
    ANAML_POSTGRES_DATABASE_SCHEMA = var.anaml_database_schema_name
    ANAML_POSTGRES_HOST            = var.postgres_host
    ANAML_POSTGRES_PORT            = var.postgres_port
    ANAML_POSTGRES_USER            = var.postgres_user

    ANAML_ADMIN_EMAIL = var.anaml_admin_email

    OIDC_CLIENT_ID     = var.oidc_client_id
    OIDC_CLIENT_SECRET = var.oidc_client_secret

    "application.conf" = templatefile("${path.module}/_templates/application.conf", {
      additional_scopes     = var.oidc_additional_scopes != null ? var.oidc_additional_scopes : []
      anaml_external_domain = var.hostname
      discovery_uri         = var.oidc_discovery_uri != null ? var.oidc_discovery_uri : ""
      enable_form_client    = var.enable_form_client
      enable_oidc_client    = var.oidc_enable

      governance_runTypeChecks = var.governance_run_type_checks ? "true" : "false"

      # If we get a kubernetes style environment variable, i.e. "$(ANAML_LICENSE_KEY)", convert it to the config expected format "${?ANAML_LICENSE_KEY}" otherwise use the value as given.
      # We do this so the terraform modules a more consistent rather than mixing the different ways to access environment variables
      license_key = try(
        // Allow Kubernetes style values and convert to Typesafe config format
        format("$${?%s}", one(regex("^\\$\\((\\w+)\\)$", var.license_key))),

        // Allow standard Typesafe config values and pass through as is
        format("%s", regex("^\\$\\{\\??\\w+\\}$", var.license_key)),

        // Allow string values
        format("\"%s\"", var.license_key),

        // If all else fails or is null
        var.license_key
      )

      license_offline_activation = var.license_offline_activation

      license_offline_response_file_path = var.license_activation_data == null ? null : "/license/ls_activation.lic"

      pac4j_loginUrl = coalesce(
        try(format("/%s", join("/", concat(compact(split("/", var.proxy_base)), ["login"]))), null),
        "/login"
      )

      permitted_user_group_id = var.oidc_permitted_users_group_id != null ? var.oidc_permitted_users_group_id : ""

      web_rootUrl = coalesce(
        var.proxy_base == "/" ? "https://${var.hostname}" : null,
        try("https://${var.hostname}/${join("/", compact(split("/", var.proxy_base)))}", null),
        "https://${var.hostname}"
      )

    })

    "log4j2.xml" = file("${path.module}/_templates/log4j2.xml")
  }
}

resource "kubernetes_secret" "anaml_server_admin_password" {
  metadata {
    name      = "${var.kubernetes_deployment_name}-admin-password"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_ADMIN_PASSWORD = var.anaml_admin_password
  }
  type = "Opaque"
}

resource "kubernetes_secret" "anaml_server_admin_api_auth" {
  metadata {
    name      = "${var.kubernetes_deployment_name}-admin-api-auth"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_ADMIN_SECRET = var.anaml_admin_secret
    ANAML_ADMIN_TOKEN  = var.anaml_admin_token
  }
  type = "Opaque"
}

resource "kubernetes_secret" "offline_license_response" {
  count = var.license_activation_data == null ? 0 : 1
  metadata {
    name      = "${var.kubernetes_deployment_name}-offline-license-response"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = {
    "ls_activation.lic" = var.license_activation_data
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
      match_labels = {
        "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
      }
    }

    template {
      metadata {
        labels = local.deployment_labels
        annotations = {
          # Trigger POD restart on config/secret changes by hashing contents
          "checksum/configmap_${kubernetes_config_map.anaml_server.metadata[0].name}"         = sha256(jsonencode(kubernetes_config_map.anaml_server.data))
          "checksum/secret_${kubernetes_secret.anaml_server_admin_password.metadata[0].name}" = sha256(jsonencode(kubernetes_secret.anaml_server_admin_password.data))
          "checksum/secret_${kubernetes_secret.anaml_server_admin_api_auth.metadata[0].name}" = sha256(jsonencode(kubernetes_secret.anaml_server_admin_api_auth.data))
        }
      }

      spec {
        service_account_name = var.kubernetes_service_account_name

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.anaml_server.metadata.0.name
          }
        }

        dynamic "volume" {
          for_each = kubernetes_secret.offline_license_response
          content {
            name = "license"
            secret {
              secret_name = volume.value.metadata.0.name
            }
          }
        }

        node_selector = var.kubernetes_node_selector

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_server_version))
            ? "${var.container_registry}/anaml-server@${var.anaml_server_version}"
            : "${var.container_registry}/anaml-server:${var.anaml_server_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_server_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

          port {
            container_port = 8080
            name           = "http-web-svc"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          # Startup probe allows enough time (180 seconds) for DB migrations to run
          startup_probe {
            http_get {
              path = "/"
              port = 8080
            }

            period_seconds        = 10
            initial_delay_seconds = 10
            timeout_seconds       = 5
            failure_threshold     = 18
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = kubernetes_secret.offline_license_response
            content {
              name       = "license"
              mount_path = "/license"
              read_only  = true
            }
          }

          env {
            name  = "JAVA_OPTS"
            value = join(" ", concat(["-Dconfig.file=/config/application.conf", "-Dlog4j2.configurationFile=/config/log4j2.xml"], var.override_java_opts))
          }

          env_from {
            config_map_ref {
              name = var.kubernetes_deployment_name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.anaml_server_admin_password.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.anaml_server_admin_api_auth.metadata[0].name
            }
          }

          dynamic "env_from" {
            for_each = var.kubernetes_container_env_from
            content {
              dynamic "secret_ref" {
                for_each = [env_from.value.secret_ref]
                content {
                  name = secret_ref.value.name
                }
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

resource "kubernetes_service" "anaml_server" {
  metadata {
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
    labels      = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
    }
    port {
      name        = "http"
      port        = 8080
      protocol    = "TCP"
      target_port = "http-web-svc"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
