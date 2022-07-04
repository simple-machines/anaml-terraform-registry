variable "anaml_route_not_found_service_version" {
  type        = string
  default     = "v0.2"
  description = "The version of anaml-route-not-found-service to deploy"
  nullable    = false
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

variable "kubernetes_deployment_replicas" {
  type    = number
  default = 1
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_deployment_name" {
  type    = string
  default = "anaml-route-not-found-service"
}

variable "container_registry" {
  type        = string
  default     = "gcr.io/anaml-release-artifacts"
  description = "The container registry to use to fetch the anaml-docs container"
  nullable    = false
}

variable "kubernetes_namespace_name" {
  type        = string
  description = "Kubernetes namespace to deploy to. This should be set if create_anaml_namespace is false"
  nullable    = false
}

variable "kubernetes_image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}

variable "kubernetes_service_annotations" {
  type = map(string)
  default = null
  description = "Kubernetes service annotations to set if any"
}

variable "kubernetes_service_type" {
  type = string
  default = "ClusterIP"
}
