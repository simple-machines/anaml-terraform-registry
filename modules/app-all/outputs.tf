output "anaml_api_url" {
  value = module.anaml-server.internal_url
}

output "kubernetes_service_account" {
  description = "The Kubernetes service account used for deployments"
  value       = var.kubernetes_service_account_name
}
