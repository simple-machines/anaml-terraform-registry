/**
 * # anaml-postgres-proxy Terraform module
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
    "app.kubernetes.io/name" = "anaml-posgres-proxy"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_postgres_proxy_version), ":", "_"),
      var.anaml_postgres_proxy_version
    )
    "app.kubernetes.io/component"  = "demo"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_deployment" "anaml_posgres_proxy" {
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
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_postgres_proxy_version))
            ? "${var.container_registry}/anaml-postgres-proxy@${var.anaml_postgres_proxy_version}"
            : "${var.container_registry}/anaml-postgres-proxy:${var.anaml_postgres_proxy_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_postgres_proxy_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

          resources {
            requests = {
              memory = "64Mi"
            }
          }

          port {
            container_port = 5432
            name           = "postgres-proxy"
          }

          env {
            name  = "ANAML_SERVER_URL"
            value = var.internal_anaml_api_url
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "anaml_posgres_proxy" {
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
      name        = "psql"
      port        = 5432
      protocol    = "TCP"
      target_port = "postgres-proxy"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
