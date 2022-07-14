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
    "app.kubernetes.io/name"       = "anaml-data-generation"
    "app.kubernetes.io/version"    = var.anaml_demo_setup_version
    "app.kubernetes.io/component"  = "demo-data"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}



resource "kubernetes_cron_job" "data-generation-daily" {
  metadata {
    name      = "data-generation-daily"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    concurrency_policy = "Replace"
    schedule           = var.cron_schedule

    job_template {
      metadata {
        name   = "data-generation-daily"
        labels = local.deployment_labels
      }
      spec {
        backoff_limit = 2
        template {
          metadata {}
          spec {
            service_account_name = var.kubernetes_service_account_name
            node_selector        = var.kubernetes_node_selector
            container {
              name              = "data-generation-daily"
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
                name = "CLUSTER"
                value = var.cluster
              }
              command = ["/work/runners/daily.sh"]
              volume_mount {
                name       = "data-generation-volume"
                mount_path = "/work/view"
              }
            }
            volume {
              name = "data-generation-volume"
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


resource "kubernetes_persistent_volume_claim" "data_generation_volume" {
  metadata {
    name      = "data-generation-volume"
    namespace = var.kubernetes_namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi" # Reduced to 10Gi while testing to save on costs
        # storage = "40Gi"
      }
    }
  }
}
