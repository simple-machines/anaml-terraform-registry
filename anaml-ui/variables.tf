variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-ui container"
}

variable "docs_url" {
  type    = string
  default = "https://example.com/docs"
}

variable "enable_new_functionality" {
  type        = bool
  description = "Enable new-style functionality in the user interface."
  default     = true
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
  default = "anaml-ui"
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
  description = "Additional annotations to add to Kubernetes anaml-ui service definition"
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

variable "skin" {
  type        = string
  nullable    = false
  default     = "anaml"
  description = "The skin to use"
}

variable "spark_history_server_url" {
  type    = string
  default = "https://example.com"
}

variable "anaml_ui_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-ui to deploy"
}
