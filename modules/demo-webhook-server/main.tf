/**
 * # demo-webhook-server Terraform module
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
    "app.kubernetes.io/name" = "webhook-server"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.webhook_server_version), ":", "_"),
      var.webhook_server_version
    )
    "app.kubernetes.io/component"  = "demo"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  port = 8090
}

resource "kubernetes_deployment" "webhook_server" {
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
      }

      spec {
        service_account_name = var.kubernetes_service_account_name
        node_selector        = var.kubernetes_node_selector

        dynamic "volume" {
          for_each = try(var.webhook_cloud_functions_svc_credentials != null, false) ? [1] : []
          content {
            name = "cloud-function-svc-credentials"
            secret {
              secret_name = kubernetes_secret.webhook_cloud_functions_svc_credentials.metadata.0.name
            }
          }
        }

        dynamic "volume" {
          for_each = try(var.webhook_vertex_svc_credentials != null, false) ? [1] : []
          content {
            name = "vertex-svc-credentials"
            secret {
              secret_name = kubernetes_secret.webhook_vertex_svc_credentials.metadata.0.name
            }
          }
        }

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.webhook_server_version))
            ? "${var.container_registry}/webhook-server@${var.webhook_server_version}"
            : "${var.container_registry}/webhook-server:${var.webhook_server_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.webhook_server_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

          resources {
            requests = {
              memory = "64Mi"
            }
          }

          port {
            container_port = local.port
            name           = "http-web-svc"
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.webhook_anaml_api_credentials.metadata.0.name
            }
          }

          env {
            name  = "ANAML_URL"
            value = var.internal_anaml_api_url
          }

          dynamic "env" {
            for_each = try(var.webhook_cloud_functions_svc_credentials != null, false) ? [1] : []
            content {
              name  = "CLOUD_FUNCTIONS_SERVICE_ACCOUNT_KEY_FILE"
              value = "/var/secrets/cloud-functions/credentials.json"
            }
          }

          dynamic "env" {
            for_each = try(var.webhook_vertex_svc_credentials != null, false) ? [1] : []
            content {
              name  = "VERTEX_SERVICE_ACCOUNT_KEY_FILE"
              value = "/var/secrets/vertex/credentials.json"
            }
          }


          env {
            name  = "PORT"
            value = local.port
          }

          dynamic "volume_mount" {
            for_each = try(var.webhook_cloud_functions_svc_credentials != null, false) ? [1] : []
            content {
              name       = "cloud-function-svc-credentials"
              mount_path = "/var/secrets/cloud-functions"
              read_only  = true
            }
          }

          dynamic "volume_mount" {
            for_each = try(var.webhook_vertex_svc_credentials != null, false) ? [1] : []
            content {
              name       = "vertex-svc-credentials"
              mount_path = "/var/secrets/vertex"
              read_only  = true
            }
          }

          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 80
          #   }

          #   initial_delay_seconds = 10
          #   period_seconds        = 10
          #   failure_threshold     = 3
          #   timeout_seconds       = 5
          # }

          # readiness_probe {
          #   http_get {
          #     path = "/"
          #     port = 80
          #   }

          #   period_seconds  = 5
          #   timeout_seconds = 5
          # }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_secret" "webhook_cloud_functions_svc_credentials" {
  count = try(var.webhook_cloud_functions_svc_credentials != null, false) ? 1 : 0
  metadata {
    name      = "webhook-server-cloud-functions-svc-credentials"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    "credentials.json" = var.webhook_cloud_functions_svc_credentials
  }
}

resource "kubernetes_secret" "webhook_vertex_svc_credentials" {
  count = try(var.webhook_vertex_svc_credentials != null, false) ? 1 : 0
  metadata {
    name      = "webhook-server-vertex-svc-credentials"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    "credentials.json" = var.webhook_vertex_svc_credentials
  }
}

resource "kubernetes_secret" "webhook_anaml_api_credentials" {
  metadata {
    name      = "webhook-server-anaml-api-credentials"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  data = {
    ANAML_APIKEY = var.anaml_api_key
    ANAML_SECRET = var.anaml_api_secret
  }
}

resource "kubernetes_service" "webhook_server" {
  metadata {
    annotations = var.kubernetes_service_annotations
    labels      = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
    }
    port {
      name        = "http"
      port        = local.port
      protocol    = "TCP"
      target_port = "http-web-svc"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
