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
