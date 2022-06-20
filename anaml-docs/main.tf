terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
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
        node_selector = {
          node_pool = var.kubernetes_deployment_node_pool
        }
        container {
          name              = var.kubernetes_deployment_name
          image             = "${var.container_registry}/anaml-docs:${var.anaml_docs_version}"
          image_pull_policy = var.kubernetes_image_pull_policy
          port {
            container_port = 80
          }
          args = ["https://${var.hostname}", "docs"]
        }
      }
    }
  }
}

# TODO: Do we want to do this (static NodePort) if it's generic? What is the alternative?
resource "kubernetes_service" "anaml_docs" {
  metadata {
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
    labels      = local.deployment_labels
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type = "NodePort"
    selector = {
      "app.kubernetes.io/name" = "anaml-docs"
    }
    port {
      name        = "http"
      port        = 8082
      protocol    = "TCP"
      target_port = 80
    }
  }
}
