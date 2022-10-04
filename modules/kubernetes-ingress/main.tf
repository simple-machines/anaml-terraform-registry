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
  labels = merge({
    "app.kubernetes.io/component"  = "networking"
    "app.kubernetes.io/created-by" = "terraform"
    "app.kubernetes.io/name"       = "anaml-all"
    "app.kubernetes.io/part-of"    = "anaml"
  }, {})
}

resource "kubernetes_ingress_v1" "anaml_ingress" {

  metadata {
    annotations = var.kubernetes_ingress_annotations
    labels      = local.labels
    name        = var.kubernetes_ingress_name
    namespace   = var.kubernetes_namespace
  }

  wait_for_load_balancer = true

  spec {

    dynamic "tls" {
      for_each = var.kubernetes_ingress_tls_secret_name != null || var.kubernetes_ingress_tls_hosts != null ? [1] : []
      content {
        hosts       = var.kubernetes_ingress_tls_hosts
        secret_name = var.kubernetes_ingress_tls_secret_name
      }
    }

    rule {
      host = var.host

      http {
        path {
          backend {
            service {
              name = "anaml-server"
              port {
                number = var.anaml_server_port
              }
            }
          }

          path = "/api/*"
        }

        path {
          backend {
            service {
              name = "anaml-server"
              port {
                number = var.anaml_server_port
              }
            }
          }

          path = "/auth/*"
        }

        path {
          backend {
            service {
              name = "anaml-docs"
              port {
                number = var.anaml_docs_port
              }
            }
          }

          path = "/docs/*"
        }

        path {
          backend {
            service {
              name = "anaml-ui"
              port {
                number = var.anaml_ui_port
              }
            }
          }

          path = "/*"
        }

        dynamic "path" {
          for_each = var.kubernetes_ingress_additional_paths
          content {
            path = path.path
            backend {
              service {
                name = path.backend.service.name
                port {
                  number = path.backend.port.number
                }
              }
            }
          }
        }
      }
    }
  }

}
