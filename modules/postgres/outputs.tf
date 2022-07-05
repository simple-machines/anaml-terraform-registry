output "host" {
  value = "postgres.${var.kubernetes_namespace}.svc.cluster.local"
}

output "port" {
  value = "5432"
}
