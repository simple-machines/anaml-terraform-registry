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
    "app.kubernetes.io/name"       = "anaml-demo-batch-data-generation"
    "app.kubernetes.io/version"    = var.anaml_demo_setup_version
    "app.kubernetes.io/component"  = "demo-data"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}



resource "kubernetes_cron_job" "data_generation" {
  metadata {
    name      = "anaml-demo-batch-data-generation"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    concurrency_policy = "Replace"
    schedule           = var.cron_schedule

    job_template {
      metadata {
        name   = "anaml-demo-batch-data-generation"
        labels = local.deployment_labels
      }
      spec {
        backoff_limit = 1
        template {
          metadata {
            labels = local.deployment_labels
          }
          spec {
            service_account_name = var.kubernetes_service_account_name
            node_selector        = var.kubernetes_node_selector
            container {
              name              = "anaml-demo-batch-data-generation"
              image             = "${var.container_registry}/anaml-demo-setup:${var.anaml_demo_setup_version}"
              image_pull_policy = var.kubernetes_image_pull_policy
              env {
                name  = "INPUT"
                value = var.input_path
              }
              env {
                name  = "OUTPUT"
                value = var.output_path
              }
              env {
                name  = "MAX_CUST"
                value = var.max_cust
              }
              env {
                name  = "MAX_SKUS"
                value = var.max_skus
              }
              env {
                name  = "CLUSTER"
                value = var.cluster
              }
              command = ["/work/runners/daily.sh"]
              volume_mount {
                name       = "anaml-demo-batch-data-generation"
                mount_path = "/work/view"
              }
              working_dir = "/work"
            }
            volume {
              name = "anaml-demo-batch-data-generation"
              persistent_volume_claim {
                claim_name = kubernetes_persistent_volume_claim.data_generation_volume.metadata.0.name
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_job" "data_generation_init" {
  metadata {
    name      = "anaml-demo-batch-data-generation-setup"
    namespace = var.kubernetes_namespace
    labels = merge(local.deployment_labels, {
      "app.kubernetes.io/name" = "anaml-demo-batch-data-generation-setup"
    })
  }

  spec {
    template {
      metadata {
        labels = merge(local.deployment_labels, {
          "app.kubernetes.io/name" = "anaml-demo-batch-data-generation-setup"
        })
      }
      spec {
        service_account_name = var.kubernetes_service_account_name
        node_selector        = var.kubernetes_node_selector
        container {
          name              = "anaml-demo-setup"
          image             = "${var.container_registry}/anaml-demo-setup:${var.anaml_demo_setup_version}"
          image_pull_policy = var.kubernetes_image_pull_policy
          env {
            name  = "OUTPUT"
            value = var.output_path
          }
          env {
            name  = "MAX_CUST"
            value = var.max_cust
          }
          env {
            name  = "MAX_SKUS"
            value = var.max_skus
          }
          command = ["/work/runners/bootstrap.sh"]
          volume_mount {
            name       = "anaml-demo-batch-data-generation"
            mount_path = "/work/view"
          }
          working_dir = "/work"
        }
        volume {
          name = "anaml-demo-batch-data-generation"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.data_generation_volume.metadata.0.name
          }
        }
      }
    }
    backoff_limit = 1
  }

  wait_for_completion = false
}


resource "kubernetes_persistent_volume_claim" "data_generation_volume" {
  metadata {
    name      = "anaml-demo-batch-data-generation"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "40Gi"
      }
    }
  }
}
