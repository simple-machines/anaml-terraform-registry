
output "kubernetes_service_name" {
  value = kubernetes_service.anaml_posgres_proxy.metadata.0.name
}

output "internal_host" {
  value = format(
    "%s.%s.svc.cluster.local",
    kubernetes_service.anaml_posgres_proxy.metadata.0.name,
    kubernetes_service.anaml_posgres_proxy.metadata.0.namespace
  )
}