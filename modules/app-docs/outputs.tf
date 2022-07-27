output "internal_url" {
  value = format(
    "http://%s.%s.svc.cluster.local",
    kubernetes_service.anaml_docs.metadata.0.name,
    kubernetes_service.anaml_docs.metadata.0.namespace
  )
}
