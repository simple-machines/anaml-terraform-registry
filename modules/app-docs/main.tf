/**
 * # app-docs Terraform module
 *
 * Th app-docs Terraform module deploys a Kubernetes Deployment and Service exposing the Anaml help documentation website.
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
    "app.kubernetes.io/name"       = "anaml-docs"
    "app.kubernetes.io/version"    = var.anaml_docs_version
    "app.kubernetes.io/component"  = "frontend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_deployment" "anaml_docs" {
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
        node_selector = var.kubernetes_node_selector

        container {
          name              = var.kubernetes_deployment_name
          image             = "${var.container_registry}/anaml-docs:${var.anaml_docs_version}"
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_docs_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy
          port {
            container_port = 80
            name           = "http-web-svc"
          }
          args = ["https://${var.hostname}", "docs"]

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

resource "kubernetes_service" "anaml_docs" {
  metadata {
    annotations = var.kubernetes_service_annotations
    labels      = local.deployment_labels
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = "anaml-docs"
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
