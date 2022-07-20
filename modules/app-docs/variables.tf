variable "anaml_docs_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-docs to deploy. I.E. \"v0.6\" or \"latest\"."
}

variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-docs container. I.E. \"australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker\""
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "The external/public hostname to use for UI links. I.E. \"anaml.example.com\""
}

variable "kubernetes_deployment_name" {
  type    = string
  description = "(Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)"
  default = "anaml-docs"
}

variable "kubernetes_deployment_replicas" {
  type    = string
  description = "(Optional) The number of desired replicas. This attribute is a string to be able to distinguish between explicit zero and not specified. Defaults to 1. For more info see [Kubernetes reference](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)"
  default = "1"
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
  description = "(Optional) Namespace defines the space within which name of the deployment must be unique."
  default = null
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
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
  description = "(Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata."
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
