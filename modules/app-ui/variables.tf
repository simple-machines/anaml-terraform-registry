variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-ui container"
}

variable "docs_url" {
  type    = string
  nullable = false
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

variable "api_url" {
  type = string
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
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_ui_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default = null

  validation {
    condition = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent"
  }
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to add to Kubernetes anaml-ui service definition"
}

variable "kubernetes_service_type" {
  type = string
  default = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer"
  }
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels to add to Kubernetes deployment"
}

variable "kubernetes_node_selector" {
  type     = map(string)
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
  nullable = false
}

variable "anaml_ui_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-ui to deploy"
}
