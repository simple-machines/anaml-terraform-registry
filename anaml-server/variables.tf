variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-server container"
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "The hostname to use for UI links"
}

variable "kubernetes_namespace" {
  type = string
}

variable "kubernetes_deployment_name" {
  type    = string
  default = "anaml-server"
}

variable "kubernetes_deployment_replicas" {
  type    = number
  default = 1
}

variable "kubernetes_image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to add to Kubernetes anaml-server service definition"
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels to add to Kubernetes deployment"
}

variable "kubernetes_secret_refs" {
  type = list(string)
  default = []
}

variable "kubernetes_deployment_node_pool" {
  type     = string
  default  = null
  nullable = true
}

variable "anaml_server_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-server to deploy"
}

variable "authentication_method" {
  type        = string
  description = "End-user authentication method. oidc or form"
  default     = "form"
  validation {
    condition     = var.authentication_method == "oidc" || var.authentication_method == "form"
    error_message = "Only 'oidc' and 'form' authentication methods are supported."
  }
}

variable "oidc_discovery_uri" {
  type        = string
  description = "OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method."
  default     = ""
}

variable "oidc_permitted_users_group_id" {
  type        = string
  description = "OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method."
  default     = ""
}

variable "oidc_additional_scopes" {
  type        = list(string)
  sensitive   = false
  description = "OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method."
  default     = []
}

variable "anaml_database_name" {
  type        = string
  description = "The name of the PostgreSQL database to use for the Anaml Server."
  default     = "anaml"
}

variable "anaml_database_schema_name" {
  type        = string
  description = "The name of the PostgreSQL schema to use for the Anaml server."
}

variable "postgres_host" {
  type = string
}

variable "postgres_port" {
  type = number
  default = "5432"
}

variable "postgres_user" {
  type = string
  default = null
}

# TODO: shouldn't do this as will be stored in state store. Refactor out
variable "postgres_password" {
  type = string
  default = null
}
