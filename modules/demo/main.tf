/**
 * # Anaml Demo Terraform module
 *
 * This Terraform module creates demo Anaml resources for entities, tables, features, feature sets, and feature stores, intended to build upon generated demo data.
 */

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-demo"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_demo_image_version), ":", "_"),
      var.anaml_demo_image_version
    )
    "app.kubernetes.io/component"  = "demo-data"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}



resource "kubernetes_cron_job" "data_generation" {
  metadata {
    name      = "anaml-demo-data-generation"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    concurrency_policy = "Replace"
    schedule           = var.cron_schedule

    job_template {
      metadata {
        name   = "anaml-demo-data-generation"
        labels = local.deployment_labels
      }
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 60 * 60 * 24 * 7
        template {
          metadata {
            labels = local.deployment_labels
          }
          spec {
            service_account_name = var.kubernetes_service_account_name
            node_selector        = var.kubernetes_node_selector
            container {
              name = "anaml-demo-data-generation"

              image = (
                can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_demo_image_version))
                ? "${var.container_registry}/anaml_demo_setup@${var.anaml_demo_image_version}"
                : "${var.container_registry}/anaml_demo_setup:${var.anaml_demo_image_version}"
              )

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
              volume_mount {
                name       = "data"
                mount_path = "/work/view"
              }
              working_dir = "/work"
            }
            volume {
              name = "data"
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
    name      = "anaml-demo-data-generation-setup"
    namespace = var.kubernetes_namespace
    labels = merge(local.deployment_labels, {
      "app.kubernetes.io/name" = "anaml-demo-data-generation-setup"
    })
  }

  spec {
    template {
      metadata {
        labels = merge(local.deployment_labels, {
          "app.kubernetes.io/name" = "anaml-demo-data-generation-setup"
        })
      }
      spec {
        service_account_name = var.kubernetes_service_account_name
        node_selector        = var.kubernetes_node_selector
        container {
          name = "anaml-demo-setup"

          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_demo_image_version))
            ? "${var.container_registry}/anaml-demo-setup@${var.anaml_demo_image_version}"
            : "${var.container_registry}/anaml-demo-setup:${var.anaml_demo_image_version}"
          )

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

          env {
            name  = "ANAML_API_URL"
            value = var.anaml_api_url
          }

          env {
            name  = "ANAML_API_USERNAME"
            value = var.anaml_api_username
          }

          env {
            name = "ANAML_API_PASSWORD"
            value_from {
              secret_key_ref {
                name     = var.kubernetes_secret_anaml_api_password_name
                key      = var.kubernetes_secret_anaml_api_password_key
                optional = false
              }
            }
          }

          env {
            name  = "ANAML_PG_HOST"
            value = var.pg_host
          }

          env {
            name = "ANAML_PG_PASSWORD"
            value_from {
              secret_key_ref {
                name     = var.kubernetes_secret_pg_password_name
                key      = var.kubernetes_secret_pg_password_key
                optional = false
              }
            }
          }

          env {
            name  = "ANAML_SPARK_SERVER_URL"
            value = var.anaml_spark_server_url
          }

          env {
            name  = "BACK_DATE"
            value = var.backdate_day_count
          }

          dynamic "env" {
            for_each = var.preview_cluster_id == null ? [1] : []
            content {
              name  = "ANAML_CREATE_LOCAL_PREVIEW_CLUSTER"
              value = "true"
            }
          }

          dynamic "env" {
            for_each = var.job_cluster_id == null ? [] : [var.job_cluster_id]
            content {
              name  = "ANAML_JOB_CLUSTER_ID"
              value = env.value
            }
          }

          args = ["bootstrap"]
        }
      }
    }
    backoff_limit = 1
  }

  wait_for_completion = false
}


resource "kubernetes_persistent_volume_claim" "data_generation_volume" {
  metadata {
    name      = "anaml-demo-data-generation"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }

  wait_until_bound = false
}
