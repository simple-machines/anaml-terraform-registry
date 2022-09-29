variable "deployments" {
  type        = list(string)
  description = "List of deployment names, i.e. ['dev', 'test']. These deployment names are used in combination with deployment_zone, with deployments being accessible under a subdomain"
}

variable "deployment_zone" {
  type        = string
  description = "The anaml deployment GCP Zone, ie au-southeast10c"
  nullable    = false
}

variable "default_service" {
  type        = string
  description = "The backend service or backend bucket to use for the loadbalancer when none of the given routing rules match."
  default     = null
}

variable "dns_zone" {
  type        = string
  description = "The root dns zone the deployments should be available under, i.e 'nonprod.anaml.app'"
  nullable    = false
}

variable "network" {
  type        = string
  description = "The GCP Network (VPC) name to deploy the load balancer"
  nullable    = false
}

variable "target_tags" {
  type        = list(string)
  description = "The GCP instance tags the loadbalancer firewall rule should target"
  nullable    = false
}

variable "name_prefix" {
  type        = string
  description = "The name prefix to use for resources, i.e. 'anaml-nonprod' or 'anaml-demo'"
}


variable "gcp_project_name" {
  type        = string
  description = "The GCP project name the loadbalancer should be deployed to"
  nullable    = false
}

variable "enable_health_check_logging" {
  type        = bool
  default     = false
  description = "(Optional) Indicates whether or not to export logs. This is false by default, which means no health check logging will be done."
}

variable "enable_backend_logging" {
  type        = bool
  default     = false
  description = "(Optional) This field denotes the logging options for the load balancer traffic served by this backend service. If logging is enabled, logs will be exported to Stackdriver"

}

variable "anaml_docs_security_policy" {
  type        = string
  default     = null
  description = "(Optional) The security policy associated with this backend service."
}

variable "anaml_ui_security_policy" {
  type        = string
  default     = null
  description = "(Optional) The security policy associated with this backend service."
}

variable "anaml_server_security_policy" {
  type        = string
  default     = null
  description = "(Optional) The security policy associated with this backend service."
}

variable "spark_history_server_security_policy" {
  type        = string
  default     = null
  description = "(Optional) The security policy associated with this backend service."
}
