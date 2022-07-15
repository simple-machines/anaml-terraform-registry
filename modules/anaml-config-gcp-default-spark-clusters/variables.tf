variable "anaml_api_hot" {
  type = string
  nullable = false
}

variable "anaml_api_username" {
  type = string
  nullable = false
}

variable "anaml_api_password" {
  type = string
  nullable = false
}

variable "anaml_spark_server_url" {
  type = string
  nullable = false
}

variable "spark_driver_host" {
  type = string
  nullable = false
}

variable "spark_driver_port" {
  type = string
  nullable = false
  default = 7078
}

variable "preview_cluster_spark_config_overrides" {
  type = map(string)
  default = {}
}

variable "preview_cluster_hive_metastore_url" {
  type = string
  default = null
}

variable "job_cluster_hive_metastore_url" {
  type = string
  default = null
}

variable "job_cluster_spark_config_overrides" {
  type = map(string)
  default = {}
}

variable "event_store_cluster_hive_metastore_url" {
  type = string
  default = null
}

variable "event_store_cluster_spark_config_overrides" {
  type = map(string)
  default = {}
}
