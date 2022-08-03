variable "anaml_demo_setup_version" {
  type        = string
  description = "The version of anaml-demo-setup container image to deploy"
  nullable    = false
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
