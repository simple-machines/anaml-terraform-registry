output "anaml_admin_api_kubernetes_secret_name" {
  value = kubernetes_secret.anaml_server_admin_api_auth.metadata[0].name
}

output "kubernetes_service_name" {
  value = kubernetes_service.anaml_server.metadata.0.name
}

output "internal_url" {
  value = "http://anaml-server.${var.kubernetes_namespace}.svc.cluster.local:8080"
}
