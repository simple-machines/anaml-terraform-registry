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
    "app.kubernetes.io/name"       = "anaml-route-not-found-service"
    "app.kubernetes.io/version"    = var.anaml_route_not_found_service_version
    "app.kubernetes.io/component"  = "frontend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_deployment" "anaml_route_not_found_service" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace_name
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
          image             = "${var.container_registry}/anaml-route-not-found-service:${var.anaml_route_not_found_service_version}"
          image_pull_policy = var.kubernetes_image_pull_policy
          port {
            container_port = 80
            name           = "http-web-svc"
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "anaml_route_not_found_service" {
  metadata {
    annotations = var.kubernetes_service_annotations
    labels      = local.deployment_labels
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace_name
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = "anaml-route-not-found-services"
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
