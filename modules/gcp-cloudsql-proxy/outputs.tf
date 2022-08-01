output "internal_url" {
  value =  var.kubernetes_service_enable ? format(
    "%s.%s.svc.cluster.local:%s",
    kubernetes_service.default.0.metadata.0.name,
    kubernetes_service.default.0.metadata.0.namespace,
    kubernetes_service.default.0.spec.port.0.port
  ) : null
}
