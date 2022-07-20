variable "anaml_route_not_found_service_version" {
  type        = string
  default     = "v0.3"
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
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_docs_version` is set to`latest`, or IfNotPresent otherwise. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default = null

  validation {
    condition = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent"
  }
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
