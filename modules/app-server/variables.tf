variable "container_registry" {
  type        = string
  nullable    = false
  description = "The container registry to use to fetch the anaml-server container"
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "The external/public hostname to use for UI links. I.E. \"anaml.example.com\""
}

variable "kubernetes_namespace" {
  type = string
  description = "(Optional) Namespace defines the space within which name of the deployment must be unique."
  default = null
}

variable "kubernetes_deployment_name" {
  type    = string
  default = "anaml-server"
  description = "(Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)"
}

variable "kubernetes_deployment_replicas" {
  type    = string
  description = "(Optional) The number of desired replicas. This attribute is a string to be able to distinguish between explicit zero and not specified. Defaults to 1. For more info see [Kubernetes reference](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)"
  default = "1"
}

variable "kubernetes_image_pull_policy" {
  type    = string
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default = null

  validation {
    condition = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent"
  }
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = null
  description = "(Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata."
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels to add to Kubernetes deployment"
}

variable "kubernetes_service_type" {
  type = string
  default = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer"
  }
}

variable "kubernetes_node_selector" {
  type     = map(string)
  default  = null
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
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
        run_as_group    = optional(number)
        run_as_user     = optional(number)
      }))

      port = optional(object({
        container_port = number
      }))
    })
  )
  default     = []
  description = "Optional sidecars to provision i.e. Google Cloud SQL Auth Proxy if deploying in GCP"
}

variable "kubernetes_container_env_from" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))
  description = "Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret_ref to use in the `postgres_user` and `postgres_password` values"
  default = []
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
  description = "The name of the Postgres database to use for the Anaml Server."
  nullable    = false
}

variable "anaml_database_schema_name" {
  type        = string
  default     = "anaml"
  description = "The name of the Postgres schema to use for the Anaml server."
  nullable    = false
}

variable "postgres_host" {
  type = string
  description = "The host name of the Postgres database to connecto to"
}

variable "postgres_port" {
  type    = number
  description = "The Postgres database port to connect to, defaults to 5432"
  default = "5432"
}

variable "postgres_user" {
  type    = string
  description = "The user to connect to Postgres as. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGUSER)`."
}

variable "postgres_password" {
  type    = string
  description = "The password for the specified Postgres user. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGPASSWORD)`."
}


variable "anaml_admin_email" {
  type        = string
  default     = null
  description = "If `enable_form_client` is `true`, the admin account email address for sign in"
}

variable "anaml_admin_password" {
  type        = string
  default     = null
  description = "If `enable_form_client` is `true`, the initial admin account password for sign in"
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


variable "kubernetes_service_account_name" {
  type = string
  default = null
}
