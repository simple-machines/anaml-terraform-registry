provider "kubernetes" {
  host                   = var.kubernetes_host
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  token                  = var.kubernetes_token
}

resource "kubernetes_deployment" "anaml_ui_deployment" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels = merge({}, var.kubernetes_deployment_labels)
  }

  spec {
    replicas = var.kubernetes_deployment_replicas

    selector {
      match_labels = {
        app = "anaml-ui"
      }
    }

    template {
      metadata {
        labels = merge({}, var.kubernetes_pod_labels)
      }

      spec {
        node_selector = {
          node_pool = "anaml-node-pool"
        }
        container {
          name              = var.kubernetes_deployment_name
          image             = "${var.container_registry}/anaml-ui:${var.anaml_ui_version}"
          image_pull_policy = var.kubernetes_image_pull_policy
          port {
            container_port = 80
          }
          env {
            name  = "ANAML_EXTERNAL_DOMAIN"
            value = var.hostname
          }
          env {
            name  = "REACT_APP_API_URL"
            value = "https://${var.hostname}/api"
          }
          env {
            name  = "REACT_APP_ENABLE_POLICY"
            value = var.enable_new_functionality
          }
          env {
            name  = "REACT_APP_FRONTEND_SKIN"
            value = var.skin
          }
          env {
            name  = "ANAML_DOCS_URL"
            value = var.docs_url
          }
          env {
            name  = "SPARK_HISTORY_SERVER"
            value = var.spark_history_server_url
          }
        }
      }
    }
  }
}
