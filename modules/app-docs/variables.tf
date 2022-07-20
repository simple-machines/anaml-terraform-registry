variable "anaml_docs_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-docs to deploy"
}

variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-docs container"
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "The hostname to use for UI links"
}

variable "kubernetes_deployment_name" {
  type    = string
  default = "anaml-docs"
}

variable "kubernetes_deployment_replicas" {
  type    = number
  default = 1
}

variable "kubernetes_image_pull_policy" {
  type    = string
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_docs_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default = null

  validation {
    condition = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent"
  }
}

variable "kubernetes_namespace" {
  type = string
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any"
}

variable "kubernetes_service_type" {
  type    = string
  default = "ClusterIP"
}
