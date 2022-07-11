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
    labels = local.deployment_labels
  }
  spec {
    selector {
      match_labels = local.deployment_labels
    }
    template {
      metadata {
        name      = var.kubernetes_deployment_name
        namespace = var.kubernetes_namespace
        labels = local.deployment_labels
      }
      spec {
        service_account_name = var.kubernetes_service_account
        node_selector = var.kubernetes_node_selector
        container {
          name  = "cloudsql-proxy"
          image = "${var.gcp_cloudsql_image_repository}:${var.gcp_cloudsql_proxy_version}"
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
