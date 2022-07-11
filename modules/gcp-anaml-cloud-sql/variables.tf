variable "postgresql_deploy_versions" {
  type        = list(any)
  description = "Versions of PostgreSQL to deploy. Can facilitate with upgrades."
  default     = ["13"]
}

variable "name_prefix" {
  type = string
  default = "anaml-"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "project_name" {
  type        = string
  description = "GCP project name."
}

variable "ip_configuration_private_network_id" {
  type = string
}

variable "ip_configuration_ipv4_enabled" {
  type = bool
  default = false
}

variable "tier" {
  type = string
  default = "db-custom-2-8192"
}

variable "disk_size" {
  type = number
  default = 20
}

variable "deletion_protection" {
  type = bool
  default = false
}

variable "insights_config_query_insights_enabled" {
  type = bool
  default = true
}

variable "insights_config_query_string_length" {
  type = number
  default = 1024
}

variable "insights_config_record_application_tags" {
  type = bool
  default = false
}

variable "insights_config_record_client_address" {
  type = bool
  default = false
}

variable "password" {
  type = string
  nullable = false
}

variable "user" {
  type = string
  default = "anaml"
}
