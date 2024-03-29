resource "kubernetes_service" "anaml_spark_server_service" {
  for_each = var.kubernetes_deployment_name

  metadata {
    name      = each.key
    namespace = var.kubernetes_namespace
    labels = merge(
      { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" },
      { "app.kubernetes.io/name" = each.key }
    )
    annotations = var.kubernetes_service_annotations_anaml_spark_server
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = each.key
    }
    port {
      name        = "http"
      port        = 8762
      protocol    = "TCP"
      target_port = 8762
    }
    port {
      name        = "driver-rpc-port"
      port        = 7078
      protocol    = "TCP"
      target_port = 7078
    }
    port {
      name        = "blockmanager"
      port        = 7079
      protocol    = "TCP"
      target_port = 7079
    }
    port {
      name        = "spark-ui"
      port        = 4040
      protocol    = "TCP"
      target_port = 4040
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}

resource "kubernetes_service" "spark_history_server_service" {
  metadata {
    name        = "spark-history-server"
    namespace   = var.kubernetes_namespace
    labels      = { for k, v in local.spark_history_server_labels : k => v if k != "app.kubernetes.io/version" }
    annotations = var.kubernetes_service_annotations_spark_history_service
  }
  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name" = local.spark_history_server_labels["app.kubernetes.io/name"]
    }
    port {
      name        = var.ssl_kubernetes_secret_pkcs12_keystore == null ? "http" : "https"
      port        = var.ssl_kubernetes_secret_pkcs12_keystore == null ? 18080 : 18480
      protocol    = "TCP"
      target_port = var.ssl_kubernetes_secret_pkcs12_keystore == null ? 18080 : 18480
    }
  }
  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
