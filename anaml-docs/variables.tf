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

variable "kubernetes_namespace" {
  type = string
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
  default = "IfNotPresent"
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to add to Kubernetes anaml-docs service definition"
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels to add to Kubernetes deployment"
}

variable "kubernetes_deployment_node_pool" {
  type     = string
  default  = null
  nullable = true
}

variable "anaml_docs_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-docs to deploy"
}
