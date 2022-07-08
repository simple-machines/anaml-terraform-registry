variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-server container"
}

variable "anaml_external_domain" {
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
  type    = set(string)
  default = []
}

variable "kubernetes_service_type" {
  type    = string
  default = "NodePort"
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "kubernetes_pod_sidecars" {
  type = set(
    object({
      name              = string,
      image             = string,
      image_pull_policy = optional(string), # Optional

      command = optional(list(string))

      env = optional(list(object({
        name  = string,
        value = string,
      })))

      env_from = optional(list(object({
        config_map_ref = object({ name = string })
        secret_ref     = object({ name = string })
      })))

      volume_mount = optional(list(object({
        name       = string,
        mount_path = string,
        read_only  = bool
      })))

      security_context = optional(object({
        run_as_non_root = optional(bool)
      }))
    })
  )
  default     = []
  description = "Optional sidecars to provision i.e. Google Cloud SQL Auth Proxy if deploying in GCP"
}

variable "anaml_server_version" {
  type        = string
  nullable    = false
  description = "The version of anaml-server to deploy"
}

variable "oidc_discovery_uri" {
  type        = string
  description = "OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method."
  default     = null
}

variable "oidc_enable" {
  type        = bool
  description = "Enable OpenID Connect login"
  default     = false
}

variable "oidc_client_id" {
  type    = string
  default = null
}

variable "oidc_client_secret" {
  type      = string
  default   = null
  sensitive = true
}

variable "enable_form_client" {
  type        = bool
  description = "Enable Login form"
  default     = false
}

variable "oidc_permitted_users_group_id" {
  type        = string
  description = "OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method."
  default     = null
}

variable "oidc_additional_scopes" {
  type        = set(string)
  default     = []
  description = "OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method."
  sensitive   = false
}

variable "anaml_database_name" {
  type        = string
  default     = "anaml"
  description = "The name of the PostgreSQL database to use for the Anaml Server."
  nullable    = false
}

variable "anaml_database_schema_name" {
  type        = string
  default     = "anaml"
  description = "The name of the PostgreSQL schema to use for the Anaml server."
  nullable    = false
}

variable "postgres_host" {
  type = string
}

variable "postgres_port" {
  type    = number
  default = "5432"
}

variable "postgres_user" {
  type    = string
  default = null
}

variable "postgres_password" {
  type    = string
  default = null
}


variable "anaml_admin_email" {
  type        = string
  default     = null
  description = "If enable_form_client is true, the admin account email address for sign in"
}

variable "anaml_admin_password" {
  type        = string
  default     = null
  description = "If enable_form_client is true, the initial admin account password for sign in"
  sensitive   = true
}

variable "anaml_admin_secret" {
  type      = string
  default   = null
  sensitive = true
}

variable "anaml_admin_token" {
  type      = string
  default   = null
  sensitive = true
}