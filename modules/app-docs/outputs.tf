output "internal_url" {
  value = "http://${kubernetes_service.anaml_docs.metadata[0].name}.${kubernetes_service.anaml_docs.metadata[0].namespace}.svc.cluster.local"
}
