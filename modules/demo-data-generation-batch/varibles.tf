variable "kubernetes_namespace" {
  type     = string
  nullable = false
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "Kubernetes service account to run the job under. Ensure this service account has access to the `input_path` and `output_path` destinations"
}

variable "cron_schedule" {
  type        = string
  default     = "0 15 * * *"
  description = "The time to schedule test data generation job. Defaults to 02:00+11:00 (AEDT) and 01:00+10:00 (AEST)"
  nullable    = false
}

variable "kubernetes_node_selector" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "anaml_demo_setup_version" {
  type        = string
  description = "The version of anaml-demo-setup container image to deploy"
  nullable    = false
}

variable "kubernetes_image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}

variable "input_path" {
  type        = string
  description = "TODO"
  nullable    = false
}

variable "output_path" {
  type        = string
  description = "TODO"
  nullable    = false
}

variable "max_cust" {
  type        = number
  default     = 200000
  description = "TODO"
  nullable    = false
}

variable "max_skus" {
  type        = number
  nullable    = false
  default     = 100000
  description = "TODO"
}

variable "container_registry" {
  type        = string
  default     = "australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"
  description = "The container registry to use to fetch the anaml-docs container"
  nullable    = false
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

variable "cluster" {
  type    = string
  default = "anaml-dataproc-cluster-small"
}

variable "run_init_job" {
  type        = bool
  default     = true
  description = "Run the init job if the input_path is empty/first time running the data-generation. Defaults to true"
}
