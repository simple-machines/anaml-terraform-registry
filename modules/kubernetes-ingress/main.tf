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
    rule {
      host = var.host

      http {
        path {
          backend {
            service {
              name = "anaml-server"
              port {
                number = 8080
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
                number = 8080
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
                number = 80
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
                number = 80
              }
            }
          }

          path = "/*"
        }
      }
    }
  }

}
