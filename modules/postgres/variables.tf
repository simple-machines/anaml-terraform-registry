variable "kubernetes_deployment_labels" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_namespace" {
  type        = string
  description = "(Optional) Namespace defines the space within which name of the deployment must be unique."
  default = null
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  nullable = true
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = {}
  description = "(Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata."
}

variable "kubernetes_service_type" {
  type = string
  default = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer."
  }
}

variable "kubernetes_persistent_volume_claim_storage_class_name" {
  type     = string
  default  = "standard"
  nullable = false
}

variable "kubernetes_persistent_volume_claim_storage_class_size" {
  type     = string
  default  = "10Gi"
  nullable = false
}

variable "password" {
  type     = string
  nullable = false
  sensitive = true
}

variable "user" {
  type     = string
  nullable = false
}

variable "enable_logstatement_logging" {
  type        = bool
  default     = false
  description = "Enable Postgres logestament=all logging for debug purposes"
}

