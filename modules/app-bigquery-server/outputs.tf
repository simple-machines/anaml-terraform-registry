# output "anaml_bigquery_server_internal_url" {
#   value = {
#     for service in kubernetes_service.anaml_bigquery_server_service : service.metadata.0.name => format(
#       "%s://%s.%s.svc.cluster.local:%s",
#       var.ssl_kubernetes_secret_pkcs12_keystore != null ? "https" : "http",
#       service.metadata.0.name,
#       service.metadata.0.namespace,
#       service.spec[0].port[0].port
#     )
#   }
# }
