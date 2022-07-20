variable "gcp_project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
  nullable    = false
}

variable "gcp_region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
}

variable "gcp_zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "name_prefix" {
  type    = string
  default = "anaml-gke"
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created."
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  nullable    = false
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
  nullable    = false
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
  nullable    = false
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
  nullable    = false
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
  nullable    = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation used for the hosted master network"
  nullable    = false
}

variable "min_anaml_app_node_pool_size" {
  type        = number
  description = "Minimum number of nodes in the animal application node pool"
  default     = 2
}

variable "max_anaml_app_node_pool_size" {
  type        = number
  description = "Maximum number of nodes in the animal application node pool"
  default     = 3
}

variable "min_anaml_spark_node_pool_size" {
  type        = number
  description = "Minimum number of nodes in the animal spark worker node pool"
  default     = 0
}

variable "max_anaml_spark_node_pool_size" {
  type        = number
  description = "Maximum number of nodes in the animal spark worker node pool"
  default     = 8
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "anaml_app_pool_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "anaml_spark_pool_machine_type" {
  type    = string
  default = "e2-highmem-4"
}


variable "maintenance_start_time" {
  type = string
  default = null
  description = "(Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format"
}

variable "maintenance_end_time" {
  type = string
  default = null
  description = "(Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format"
}
