output "spark_history_server_internal_url" {
  value = format(
    "%s://%s.%s.svc.cluster.local:%s",
    var.ssl_kubernetes_secret_pkcs12_keystore != null ? "https" : "http",
    kubernetes_service.spark_history_server_service.metadata.0.name,
    kubernetes_service.spark_history_server_service.metadata.0.namespace,
    kubernetes_service.spark_history_server_service.spec[0].port[0].port
  )
}

output "anaml_spark_server_internal_url" {
  value = {
    for service in kubernetes_service.anaml_spark_server_service : service.metadata.0.name => format(
      "%s://%s.%s.svc.cluster.local:%s",
      var.ssl_kubernetes_secret_pkcs12_keystore != null ? "https" : "http",
      service.metadata.0.name,
      service.metadata.0.namespace,
      service.spec[0].port[0].port
    )
  }
}
