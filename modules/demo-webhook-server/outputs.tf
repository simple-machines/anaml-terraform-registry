# output "internal_url" {
#   value = format(
#     "http://%s.%s.svc.cluster.local",
#     kubernetes_service.anaml_docs.metadata.0.name,
#     kubernetes_service.anaml_docs.metadata.0.namespace
#   )
# }

# output "kubernetes_service_name" {
#   value = kubernetes_service.anaml_docs.metadata.0.name
# }

# output "kubernetes_service_port_name" {
#   value = kubernetes_service.anaml_docs.spec.0.port.0.name
# }

# output "kubernetes_service_port_number" {
#   value = kubernetes_service.anaml_docs.spec.0.port.0.port
# }
