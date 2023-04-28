/**
 * # app-docs Terraform module
 *
 * The app-docs Terraform module deploys a Kubernetes Deployment and Service exposing the Anaml help documentation website.
 *
 * ## Terminating SSL inside the pod
 * By default Anaml Docs uses plain HTTP and delegates SSL termination to Kubernetes Ingress.
 *
 * If you wish to terminate SSL inside the pod, you should:
 *
 * 1) Create a Kubernetes Secret containing the SSL certificate and key in PEM format with the names "tls.crt" for the certificate and "tls.key" for the key, either using Terraform or kubectl. Below is an example using kubectl.
 * ```
 * kubectl create secret generic anaml-ui-ssl-certs \
 *   --from-file=tls.crt=./tls.crt \
 *   --from-file=tls.key=./tls.key
 * ```
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
    "app.kubernetes.io/name"    = "anaml-docs"
    "app.kubernetes.io/version" = var.anaml_docs_version
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_docs_version), ":", "_"),
      var.anaml_docs_version
    )
    "app.kubernetes.io/component"  = "frontend"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)


  port = var.kubernetes_secret_ssl != null ? 443 : 80
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
      match_labels = {
        "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
      }
    }

    template {
      metadata {
        labels = local.deployment_labels
      }

      spec {
        node_selector = var.kubernetes_node_selector

        dynamic "volume" {
          for_each = var.kubernetes_secret_ssl == null ? [] : [var.kubernetes_secret_ssl]
          content {
            name = "certificates"
            secret {
              secret_name  = volume.value
              optional     = "false"
              default_mode = "0444"
            }
          }
        }

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_docs_version))
            ? "${var.container_registry}/anaml-docs@${var.anaml_docs_version}"
            : "${var.container_registry}/anaml-docs:${var.anaml_docs_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_docs_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

          resources {
            requests = {
              memory = "16Mi"
            }
          }

          port {
            container_port = local.port
            name           = "http-web-svc"
          }
          args = ["https://${var.hostname}", "docs"]

          dynamic "volume_mount" {
            for_each = var.kubernetes_secret_ssl == null ? [] : ["certificates"]
            content {
              name       = volume_mount.value
              mount_path = "/certificates"
              read_only  = true
            }
          }

          dynamic "env" {
            for_each = var.skin == null ? [] : [var.skin]
            content {
              name  = "REACT_APP_FRONTEND_SKIN"
              value = env.value
            }
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = local.port == 443 ? "HTTPS" : "HTTP"
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = local.port == 443 ? "HTTPS" : "HTTP"
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
      name        = var.kubernetes_secret_ssl != null ? "https" : "http"
      port        = local.port
      protocol    = "TCP"
      target_port = "http-web-svc"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
