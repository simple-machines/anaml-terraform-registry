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

    ANAML_ADMIN_EMAIL    = var.anaml_admin_email
    ANAML_ADMIN_PASSWORD = var.anaml_admin_password
    ANAML_ADMIN_SECRET   = var.anaml_admin_secret
    ANAML_ADMIN_TOKEN    = var.anaml_admin_token

    OIDC_CLIENT_ID     = var.oidc_client_id
    OIDC_CLIENT_SECRET = var.oidc_client_secret

    "application.conf" = templatefile("${path.module}/_templates/application.conf", {
      anaml_external_domain   = var.anaml_external_domain
      enable_oidc_client      = var.oidc_enable
      enable_form_client      = var.enable_form_client
      discovery_uri           = var.oidc_discovery_uri != null ? var.oidc_discovery_uri : ""
      permitted_user_group_id = var.oidc_permitted_users_group_id != null ? var.oidc_permitted_users_group_id : ""
      additional_scopes       = var.oidc_additional_scopes != null ? var.oidc_additional_scopes : []
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

        node_selector = var.kubernetes_node_selector

        container {
          name              = var.kubernetes_deployment_name
          image             = "${var.container_registry}/anaml-server:${var.anaml_server_version}"
          image_pull_policy = var.kubernetes_image_pull_policy

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

            period_seconds  = 10
            initial_delay_seconds = 10
            timeout_seconds = 5
            failure_threshold = 18
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }

          env {
            name  = "JAVA_OPTS"
            value = "-Dconfig.file=/config/application.conf -Dlog4j2.configurationFile=/config/log4j2.xml"
          }

          env_from {
            config_map_ref {
              name = var.kubernetes_deployment_name
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

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "anaml_server" {
  metadata {
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
    labels      = local.deployment_labels
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = "anaml-server"
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
