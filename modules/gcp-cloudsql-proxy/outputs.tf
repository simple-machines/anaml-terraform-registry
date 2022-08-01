output "host" {
  value =  var.kubernetes_service_enable ? format(
    "%s.%s.svc.cluster.local",
    kubernetes_service.default.0.metadata.0.name,
    kubernetes_service.default.0.metadata.0.namespace
  ) : null
}
