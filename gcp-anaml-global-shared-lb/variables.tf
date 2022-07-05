variable "deployments" {
  type = list(string)
}

variable "deployment_zone" {
  type = string
  nullable = false
}

variable "default_service" {
  type = string
  description = "The backend service or backend bucket to use when none of the given routing rules match."
  default = null
}

variable "dns_zone" {
  type = string
  nullable = false
}

variable "network" {
  type     = string
  nullable = false
}

variable "target_tags" {
  type = list(string)
}

variable "name_prefix" {
  type = string
}


variable "gcp_project_name" {
  type     = string
  nullable = false
}
