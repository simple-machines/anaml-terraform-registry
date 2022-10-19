variable "anaml_api_password" {
  type = string
}

variable "anaml_api_url" {
  type = string
}

variable "anaml_api_username" {
  type = string
}

variable "anaml_demo_image_version" {
  type        = string
  description = "The version of oniomania (https://github.com/simple-machines/anaml-devops/tree/master/docker/anaml-demo-setup) container image to deploy"
  default     = "faaa2511bd9010678b9af31b189a81e8b183e824"
  nullable    = false
}

variable "anaml_server_url" {
  type = string
}

variable "anaml_spark_server_url" {
  type = string
}

variable "backdate_day_count" {
  type        = number
  default     = 30
  description = "Number of days to generate backdated data for"
}

variable "container_registry" {
  type        = string
  default     = "australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"
  description = "The container registry to use to fetch the anaml-docs container"
  nullable    = false
}

variable "cron_schedule" {
  type        = string
  default     = "0 15 * * *"
  description = "The t 01:00+10:00 (AEST)"
  nullable    = false
}

variable "input_path" {
  type     = string
  nullable = false
}

variable "job_cluster_id" {
  type = string
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

variable "kubernetes_image_pull_policy" {
  type    = string
  default = "IfNotPresent"
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

variable "kubernetes_secret_anaml_api_password_key" {
  type     = string
  nullable = false
}

variable "kubernetes_secret_anaml_api_password_name" {
  type     = string
  nullable = false
}

variable "kubernetes_secret_pg_password_key" {
  type     = string
  nullable = false
}

variable "kubernetes_secret_pg_password_name" {
  type     = string
  nullable = false
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "Kubernetes service account to run the job under. Ensure this service account has access to the `input_path` and `output_path` destinations"
}

variable "max_cust" {
  type     = number
  default  = 200000
  nullable = false
}

variable "max_skus" {
  type     = number
  nullable = false
  default  = 100000
}

variable "output_path" {
  type     = string
  nullable = false
}

variable "pg_host" {
  type = string
}

variable "pg_password" {
  type = string
}

variable "preview_cluster_id" {
  type = string
}
