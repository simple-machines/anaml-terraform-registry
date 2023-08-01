resource "kubernetes_service" "anaml_bigquery_server_service" {
  for_each = var.kubernetes_deployment_name

  metadata {
    name      = each.key
    namespace = var.kubernetes_namespace
    labels = merge(
      { for k, v in local.anaml_bigquery_server_labels : k => v if k != "app.kubernetes.io/version" },
      { "app.kubernetes.io/name" = each.key }
    )
    annotations = var.kubernetes_service_annotations_anaml_bigquery_server
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
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
