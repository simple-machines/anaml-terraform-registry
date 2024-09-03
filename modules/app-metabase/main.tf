/**
 * # metabase Terraform module
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
    "app.kubernetes.io/name" = "metabase"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.metabase_version), ":", "_"),
      var.metabase_version
    )
    "app.kubernetes.io/component"  = "demo"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_deployment" "metabase" {
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

        container {
          name = var.kubernetes_deployment_name
          image = "metabase/metabase:latest"
          image_pull_policy = "Always"

          resources {
            requests = {
              memory = "64Mi"
            }
          }

          port {
            container_port = 3000
            name           = "metabase"
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "metabase" {
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
      port        = 3000
      protocol    = "TCP"
      target_port = "metabase"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
