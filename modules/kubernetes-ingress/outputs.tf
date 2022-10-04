data "kubernetes_ingress_v1" "default" {
  metadata {
    name      = kubernetes_ingress_v1.anaml_ingress.metadata[0].name
    namespace = var.kubernetes_namespace
  }
}

output "dns_hostname" {
  value = data.kubernetes_ingress_v1.default.status.0.load_balancer.0.ingress.0.hostname
}
