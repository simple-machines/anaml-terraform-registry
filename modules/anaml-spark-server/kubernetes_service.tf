resource "kubernetes_service" "anaml_spark_server_service" {
  metadata {
    name        = "anaml-spark-server"
    namespace   = var.kubernetes_namespace
    labels      = local.anaml_spark_server_labels
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type     = var.kubernetes_service_type
    selector = local.anaml_spark_server_labels
    port {
      name        = "http"
      port        = 8762
      protocol    = "TCP"
      target_port = 8762
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}

resource "kubernetes_service" "anaml_spark_driver" {
  metadata {
    name        = "anaml-spark-driver"
    namespace   = var.kubernetes_namespace
    labels      = local.anaml_spark_server_labels
    annotations = var.kubernetes_service_annotations
  }
  spec {
    type     = var.kubernetes_service_type
    selector = local.anaml_spark_server_labels
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
