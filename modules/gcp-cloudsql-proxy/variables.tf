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
  default = "IfNotPresent"
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
  type    = string
  default = "ClusterIP"
}
