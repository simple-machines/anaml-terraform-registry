variable "gcp_project_name" {
  type     = string
  nullable = false
}

variable "gcp_region" {
  type     = string
  nullable = false
}

variable "gcp_zones" {
  type     = list(string)
  nullable = false
}

variable "name_prefix" {
  type    = string
  default = "anaml-gke"
}

variable "service_account" {
  type     = string
  nullable = false
}

variable "kubernetes_version" {
  type     = string
  nullable = false
}

variable "network" {
  type     = string
  nullable = false
}

variable "subnetwork" {
  type     = string
  nullable = false
}

variable "ip_range_pods" {
  type     = string
  nullable = false
}

variable "ip_range_services" {
  type     = string
  nullable = false
}

variable "master_ipv4_cidr_block" {
  type     = string
  nullable = false
}

variable "min_anaml_node_pool_size" {
  type    = number
  default = 2
}

variable "max_anaml_node_pool_size" {
  type    = number
  default = 3
}

variable "regional" {
  type    = bool
  default = true
}

variable "anaml_app_pool_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "anaml_spark_pool_machine_type" {
  type    = string
  default = "e2-highmem-4"
}
