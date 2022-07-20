variable "gcp_cloudsql_proxy_version" {
  type    = string
  default = "1.31.0"
}

variable "kubernetes_deployment_name" {
  type    = string
  default = "cloudsql-proxy"
}

variable "kubernetes_deployment_replicas" {
  type    = number
  default = 1
}

variable "kubernetes_service_enable" {
  type    = bool
  default = false
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

variable "kubernetes_service_account" {
  type    = string
  default = null
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}


# Available - See https://github.com/GoogleCloudPlatform/cloudsql-proxy
#  - gcr.io/cloudsql-docker/gce-proxy
#  - us.gcr.io/cloudsql-docker/gce-proxy
#  - eu.gcr.io/cloudsql-docker/gce-proxy
#  - asia.gcr.io/cloudsql-docker/gce-proxy
variable "gcp_cloudsql_image_repository" {
  type    = string
  default = "gcr.io/cloudsql-docker/gce-proxy"
}

variable "gcp_cloudsql_use_private_ip" {
  type    = bool
  default = true
}

variable "gcp_cloudsql_instances" {
  type = list(string)
}

variable "gcp_cloudsql_structured_logs" {
  type    = bool
  default = true
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any"
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
