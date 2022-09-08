terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.1"
    }
  }
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-ui"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_ui_version), ":", "_"),
      var.anaml_ui_version
    )
    "app.kubernetes.io/component"   = "frontend"
    "app.kubernetes.io/part-of"     = "anaml"
    "app.kubernetes.io/created-by"  = "terraform"
    "terraform/deployment-instance" = random_uuid.deployment_instance.result
  }, var.kubernetes_deployment_labels)
}

# Added to allow running multiple independent instances (useful for test/development)
resource "random_uuid" "deployment_instance" {}

resource "kubernetes_deployment" "anaml_ui" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  spec {
    replicas = var.kubernetes_deployment_replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name"        = local.deployment_labels["app.kubernetes.io/name"]
        "terraform/deployment-instance" = local.deployment_labels["terraform/deployment-instance"]
      }
    }

    template {
      metadata {
        labels = local.deployment_labels
      }

      spec {
        node_selector = var.kubernetes_node_selector

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_ui_version))
            ? "${var.container_registry}/anaml-ui@${var.anaml_ui_version}"
            : "${var.container_registry}/anaml-ui:${var.anaml_ui_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy
          port {
            container_port = 80
            name           = "http-web-svc"
          }

          env {
            name  = "ANAML_DOCS_URL"
            value = var.docs_url
          }

          env {
            name  = "ANAML_EXTERNAL_DOMAIN"
            value = var.hostname
          }

          env {
            name  = "ANAML_SERVER_URL"
            value = var.anaml_server_url
          }

          env {
            name  = "REACT_APP_API_URL"
            value = var.api_url
          }

          env {
            name  = "REACT_APP_FRONTEND_SKIN"
            value = var.skin
          }

          env {
            name  = "REACT_APP_UI_BASEPATH"
            value = var.basepath
          }

          env {
            name  = "SPARK_HISTORY_SERVER"
            value = var.spark_history_server_url
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }

            period_seconds  = 5
            timeout_seconds = 5
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "anaml_ui" {
  metadata {
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
    labels      = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name"        = local.deployment_labels["app.kubernetes.io/name"]
      "terraform/deployment-instance" = local.deployment_labels["terraform/deployment-instance"]
    }
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "http-web-svc"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
