/**
 * # app-routing-not-found-service Terraform module
 *
 * :warning: It's likely you do not want to deploy this!
 *
 * ## What is app-routing-not-found service?
 * app-routing-not-found service is used in a multi host hosting environment when using a single GCP Global Load Balancer serving multiple sites where you must provided a default backend and want to serve a branded "404 Page Not Found" when a route does not match.
 *
 * This module deploys a Kubernetes Deployment and Service running an HTTP webserver that returns a static HTTP 404 page for every web request.
 *
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
          image             = "${var.container_registry}/anaml-route-not-found-service:${var.anaml_route_not_found_service_version}"
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_route_not_found_service_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy
          port {
            container_port = 8080
            name           = "http-web-svc"
          }
        }

        security_context {
          run_as_non_root = true
          run_as_user = 101 #nginx user in container
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
    namespace   = var.kubernetes_namespace
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
