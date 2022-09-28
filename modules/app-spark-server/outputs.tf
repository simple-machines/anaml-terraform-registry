output "spark_history_server_internal_url" {
  value = format(
    "%s://%s.%s.svc.cluster.local:%s",
    var.ssl_kubernetes_secret_pkcs12_keystore != null ? "https" : "http",
    kubernetes_service.spark_history_server_service.metadata.0.name,
    kubernetes_service.spark_history_server_service.metadata.0.namespace,
    kubernetes_service.spark_history_server_service.spec[0].port[0].port
  )
}
