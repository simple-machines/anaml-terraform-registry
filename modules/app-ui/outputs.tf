output "kubernetes_service_name" {
  value = kubernetes_service.anaml_ui.metadata.0.name
}

output "kubernetes_service_port_name" {
  value = kubernetes_service.anaml_ui.spec.0.port.0.name
}

output "kubernetes_service_port_number" {
  value = kubernetes_service.anaml_ui.spec.0.port.0.port
}

output "internal_url" {
  value = format(
    "http://%s.%s.svc.cluster.local",
    kubernetes_service.anaml_ui.metadata.0.name,
    kubernetes_service.anaml_ui.metadata.0.namespace
  )
}
