output "anaml_admin_api_kubernetes_secret_name" {
  value = kubernetes_secret.anaml_server_admin_api_auth.metadata[0].name
}

output "anaml_api_url" {
  value = "http://anaml-server.${var.kubernetes_namespace}.svc.cluster.local:8080"
}
