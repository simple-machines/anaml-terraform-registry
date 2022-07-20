/**
 * # Google Cloud SQL Auth Proxy Kubernetes deployment
 *
 * This module deploys a standalone instance of [Google Cloud SQL Auth proxy](https://github.com/GoogleCloudPlatform/cloudsql-proxy)
 *
 * We advice against deploying this as a standalone service, see Google's [Use the Cloud SQL Auth proxy in a production environment](https://cloud.google.com/sql/docs/postgres/sql-proxy#production-environment). It's likely you want to instead declare a sidecar for `anaml-server` if you use Google Cloud SQL.
 *
 * This module is available primarily for debug purposes where you want to connect to the Google Cloud SQL database manually. In which case it's recommended you forward the port locally instead of enabling a Kubernetes Service:
 *
 * ```
 * NAMESPACE=anaml-dev
 * POD=$(kubectl -n $NAMESPACE get pods -l 'app.kubernetes.io/name=cloudsql-proxy' -o name)
 * kubectl -n $NAMESPACE port-forward $POD 5432:5432
 *
 * psql -h 127.0.0.1 -p 5432 anaml anaml
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
    "app.kubernetes.io/name"       = "cloudsql-proxy"
    "app.kubernetes.io/version"    = var.gcp_cloudsql_proxy_version
    "app.kubernetes.io/component"  = "database"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}

resource "kubernetes_deployment" "default" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    selector {
      match_labels = local.deployment_labels
    }
    template {
      metadata {
        name      = var.kubernetes_deployment_name
        namespace = var.kubernetes_namespace
        labels    = local.deployment_labels
      }
      spec {
        service_account_name = var.kubernetes_service_account
        node_selector        = var.kubernetes_node_selector
        container {
          name  = var.kubernetes_deployment_name
          image = "${var.gcp_cloudsql_image_repository}:${var.gcp_cloudsql_proxy_version}"
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.gcp_cloudsql_proxy_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy
          command = flatten([
            ["/cloud_sql_proxy"],
            ["-dir=/cloudsql"],
            ["-instances=${join(",", var.gcp_cloudsql_instances)}=tcp:5432"],
            ["-log_debug_stdout"],
            ["-use_http_health_check"],
            var.gcp_cloudsql_structured_logs ? ["-structured_logs"] : [],
            var.gcp_cloudsql_use_private_ip ? ["-ip_address_types=PRIVATE"] : []
          ])
          security_context {
            run_as_non_root = true
            run_as_group    = 2000
            run_as_user     = 1000
          }

          port {
            container_port = 5432
            name           = "postgres"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "default" {
  count = var.kubernetes_service_enable ? 1 : 0
  metadata {
    annotations = var.kubernetes_service_annotations
    labels      = local.deployment_labels
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
  }

  spec {
    type     = var.kubernetes_service_type
    selector = local.deployment_labels
    port {
      name        = "postgres"
      port        = 5432
      protocol    = "TCP"
      target_port = "postgress"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
