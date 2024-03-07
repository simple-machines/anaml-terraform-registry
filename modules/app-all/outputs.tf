output "anaml_internal_server_url" {
  description = "The anaml-server url to use from within kubernetes"
  value       = module.anaml-server.internal_url
}

output "kubernetes_service_account" {
  description = "The Kubernetes service account used for deployments"
  value       = var.kubernetes_service_account_name
}

output "kubernetes_service_account_spark_executor_driver" {
  description = "The Kubernetes service account used for Spark"
  value       = module.spark-server.kubernetes_service_account
}

output "kubernetes_namespace" {
  description = "The Kubernetes used for deployments"
  value       = var.kubernetes_namespace_name
}

output "kubernetes_service_name_anaml_server" {
  value = module.anaml-server.kubernetes_service_name
}

output "anaml_server_port" {
  value = module.anaml-server.kubernetes_service_port_number
}

output "ingress_dns_hostname" {
  value = one(module.ingress[*].dns_hostname)
}


output "anaml_spark_server_internal_url" {
  value = module.spark-server.anaml_spark_server_internal_url
}
