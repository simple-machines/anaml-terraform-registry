variable "anaml_producer_demo_version" {
  type        = string
  description = "The version of anaml-demo-setup container image to deploy"
  nullable    = false
}

variable "container_registry" {
  type        = string
  default     = "australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"
  description = "The container registry to use to fetch the anaml-docs container"
  nullable    = false
}

variable "google_project_id" {
  type = string
}

variable "google_bucket" {
  type = string
}

variable "customer_source_path" {
  type = string
}

variable "kafka_bootstrap_servers" {
  type = string
}

variable "kafka_additional_config" {
  type = map(string)
  default = {}
}

variable "kafka_schema_registry_url" {
  type = string
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

variable "kubernetes_namespace" {
  type     = string
  nullable = false
}

variable "kubernetes_node_selector" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "kubernetes_image_pull_policy" {
  type        = string
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default     = null

  validation {
    condition     = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent."
  }
}
