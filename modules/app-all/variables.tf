variable "anaml_version" {
  type        = string
  description = "Anaml version to deploy. This should be a valid Anaml container tag"
  nullable    = false
}

variable "container_registry" {
  type     = string
  default  = "australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"
  nullable = false
}

variable "hostname" {
  type        = string
  description = "The hostname Anaml will be accessed from. i.e 'dev.nonprod.anaml.app'"
  nullable    = false
}

variable "https_urls" {
  type     = bool
  default  = true
  nullable = false
}

variable "kubernetes_container_env_from_anaml_server" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))
  description = "Inject additional `env_from` values in to the anaml_server deployment"
  default     = []
}

variable "kubernetes_ingress_enable" {
  type        = bool
  default     = false
  description = "If true, deploy an ingress for Anaml"
}

variable "kubernetes_ingress_hostname" {
  type        = string
  default     = null
  description = "Optional hostname to use for the Anaml ingress definition when kubernetes_ingress_enable is true"
}

variable "kubernetes_ingress_name" {
  type        = string
  default     = "anaml"
  description = "The name to use for the Anaml ingress definition"
}

variable "kubernetes_namespace_create" {
  type        = bool
  default     = false
  description = "If the given namespace should be created as part of this deployment"
}

variable "kubernetes_namespace_name" {
  type        = string
  description = "Kubernetes namespace to deploy to. This should be set if create_anaml_namespace is false"
  nullable    = false
}

variable "kubernetes_pod_node_selector_app" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the **apps** pod's to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "kubernetes_pod_node_selector_postgres" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the **postgres** pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "kubernetes_pod_node_selector_spark_executor" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the **spark_executor** pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "kubernetes_service_annotations_anaml_docs" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any for anaml-docs"
}

variable "kubernetes_service_annotations_anaml_server" {
  type        = map(string)
  default     = null
  description = "Optional Kubernetes service annotations to set for anaml-server"
}

variable "kubernetes_service_annotations_anaml_ui" {
  type        = map(string)
  default     = null
  description = "Optional Kubernetes service annotations to set for anaml-ui"
  nullable    = true
}

variable "kubernetes_service_annotations_postgres" {
  type        = map(string)
  default     = null
  description = "Optional Kubernetes service annotations to set for Postgres"
  nullable    = true
}

variable "kubernetes_service_enable_postgres" {
  type        = bool
  default     = false
  description = "If true, deploy a Postgres pod for Anaml to use. If false you should provide the Postgres host details"
  nullable    = false
}

variable "kubernetes_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "The Kubernetes service type to use. Valid values are ClusterIP, ExternalName, LoadBalancer or NodeIP"
  nullable    = false

  validation {
    condition     = contains(["ClusterIP", "ExternalName", "LoadBalancer", "NodeIP"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ClusterIP, ExternalName, LoadBalancer or NodeIP"
  }
}

variable "override_anaml_docs_version" {
  type        = string
  default     = null
  description = "anaml-docs version override. This value should contain the container tag to deploy"
}

variable "override_anaml_server_version" {
  type        = string
  default     = null
  description = "anaml-server version override. This value should contain the container tag to deploy"
}

variable "override_anaml_spark_server_version" {
  type        = string
  default     = null
  description = "anaml-spark-server version override. This value should contain the container tag to deploy"
}

variable "override_anaml_spark_server_spark_config_overrides" {
  type    = map(string)
  default = {}
}

variable "override_anaml_spark_server_spark_log_directory" {
  type     = string
  nullable = false
}


variable "override_anaml_spark_server_additional_volumes" {
  type = list(object({
    name = string

    secret = optional(object({
      secret_name = string
    }))

    config_map = optional(object({
      name = string
    }))
  }))

  default = []
}

variable "override_anaml_spark_server_additional_env_values" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "override_anaml_spark_server_additional_volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}


variable "override_spark_history_server_additional_volumes" {
  type = list(object({
    name = string

    secret = optional(object({
      secret_name = string
    }))

    config_map = optional(object({
      name = string
    }))
  }))

  default = []
}

variable "override_spark_history_server_additional_env_values" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "override_spark_history_server_additional_volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}

variable "override_anaml_server_anaml_database_schema_name" {
  type    = string
  default = null
}



variable "override_anaml_ui_version" {
  type        = string
  default     = null
  description = "anaml-ui version override. This value should contain the container tag to deploy"
}

variable "override_anaml_ui_api_url" {
  type        = string
  default     = null
  description = "anaml-ui api_url override"
}

variable "override_anaml_ui_skin" {
  type        = string
  default     = "anaml"
  description = "anaml-ui skin override"
}

variable "postgres_host" {
  type        = string
  default     = null
  description = "The postgres host to use if kubernetes_service_enable_postgres if false and using an external postgres database"
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "postgres_user" {
  type        = string
  default     = "anaml"
  description = "The postgres user to use if kubernetes_service_enable_postgres if false and using an external postgres database"
  nullable    = false
}

variable "postgres_password" {
  type        = string
  description = "The pstgress user password to connect to remote DB. If kubernetes_service_enable_porstgres is true this value is used to set the local postgres password"
  default     = null
  sensitive   = true
}

variable "oidc_enable" {
  type        = bool
  description = "Enable OpenID Connect login"
  default     = false
}

variable "enable_form_client" {
  type        = bool
  description = "Enable Login form"
  default     = false
}

variable "override_anaml_ui_enable_new_functionality" {
  type        = bool
  default     = false
  description = "true|false - whether to enable new functionality behind feature flags"
}

variable "override_anaml_spark_server_checkpoint_location" {
  type = string
}

variable "oidc_client_id" {
  type        = string
  description = "OpenID Connect client identifier. Required when using OIDC authentication method."
  default     = null
}

variable "oidc_client_secret" {
  type        = string
  sensitive   = true
  description = "OpenID Connect client secret. Required when using OIDC authentication method."
  default     = null
}

variable "oidc_tenant_id" {
  type        = string
  description = "OpenID Connect tenant identifier. Required when using OIDC authentication method."
  default     = null
}

variable "oidc_discovery_uri" {
  type        = string
  description = "OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method."
  default     = null
}

variable "oidc_permitted_users_group_id" {
  type        = string
  description = "OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method."
  default     = null
}

variable "oidc_additional_scopes" {
  type        = list(string)
  sensitive   = false
  description = "OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method."
  default     = []
}

variable "anaml_admin_email" {
  type    = string
  default = null
}

variable "anaml_admin_password" {
  type      = string
  default   = null
  sensitive = true
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

variable "kubernetes_persistent_volume_claim_storage_class_name_postgres" {
  type    = string
  default = null
}

variable "kubernetes_pod_anaml_server_sidecars" {
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

variable "kubernetes_pod_anaml_spark_server_sidecars" {
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

variable "kubernetes_service_account_name" {
  type    = string
  default = null
}

variable "kubernetes_service_account_create" {
  type    = bool
  default = false
}

variable "kubernetes_service_account_annotations" {
  type    = map(string)
  default = {}
}


variable "kubernetes_service_annotations_anaml_spark_server" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any"
}

variable "kubernetes_service_annotations_spark_driver" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any"
}

variable "kubernetes_service_annotations_spark_history_service" {
  type        = map(string)
  default     = null
  description = "Kubernetes service annotations to set if any"
}

variable "license_key" {
  type        = string
  description = "Your ANAML license key. If the license key is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(ANAML_LICENSE_KEY)`."
  default     = null
}
