variable "kubernetes_deployment_labels" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_namespace" {
  type        = string
  nullable    = false
  description = "Kubernetes namespace to deploy to"
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to add to Kubernetes Postgres service definition"
}

variable "kubernetes_service_type" {
  type    = string
  default = "NodePort"
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

