variable "kubernetes_namespace" {
  type        = string
  description = "(Optional) Namespace defines the space within which name of the deployment must be unique."
  default     = null
}

variable "kubernetes_deployment_labels" {
  type        = map(string)
  default     = null
  description = "Kubernetes labels to set if any. These values will be merged with the defaults"
}

# This is the Driver deployment so deploy to the app pool so the expensive spark pool can scale down
# The driver is configured so workers will use anaml-spark-pool
variable "kubernetes_node_selector_app" {
  type = map(string)
  default = {
    node_pool = "anaml-app-pool"
  }
  nullable = true
}

variable "kubernetes_node_selector_spark_executor" {
  type = map(string)
  default = {
    node_pool = "anaml-spark-pool"
  }
  nullable = true
}

variable "kubernetes_deployment_name" {
  type        = string
  default     = "anaml-spark-server"
  description = "(Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)"
}

variable "kubernetes_image_pull_policy" {
  type        = string
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_spark_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default     = null

  validation {
    condition     = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent"
  }
}

variable "kubernetes_service_account" {
  type    = string
  default = null
}

variable "kubernetes_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition     = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer"
  }
}

variable "anaml_spark_server_version" {
  type     = string
  nullable = false
}

variable "container_registry" {
  type     = string
  nullable = false
}

variable "spark_config_overrides" {
  type        = map(string)
  default     = {}
  description = "Additional spark config / overrides to merge into spark conf. This is useful for AWS/GCP specfic values"
}

variable "spark_log_directory" {
  type        = string
  nullable    = false
  description = "The log directory used for spark.eventLodDir and spark.history.fs.logDirectory"
}

variable "anaml_server_url" {
  type     = string
  default  = "http://anaml-server.anaml.svc.cluster.local:8080"
  nullable = false
}

variable "anaml_server_user" {
  type     = string
  nullable = false
}

variable "anaml_server_password" {
  type     = string
  nullable = false
}

variable "checkpoint_location" {
  type     = string
  nullable = false
}

variable "additional_env_values" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "additional_volumes" {
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

variable "additional_env_from" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))

  default = []
}

variable "additional_volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}


variable "spark_history_server_additional_env_values" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "spark_history_server_additional_volumes" {
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

variable "spark_history_server_additional_env_from" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))

  default = []
}

variable "spark_history_server_additional_volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}

variable "postgres_host" {
  type     = string
  nullable = false
}

variable "postgres_port" {
  type     = number
  default  = 5432
  nullable = false
}

variable "postgres_password" {
  type     = string
  nullable = false
}

variable "anaml_database_name" {
  type     = string
  default  = "anaml"
  nullable = false
}


variable "anaml_database_schema_name" {
  type     = string
  default  = "anaml"
  nullable = false
}

variable "kubernetes_service_annotations_anaml_spark_server" {
  type        = map(string)
  default     = null
  description = "(Optional) An unstructured key value map stored with the **anaml_spark_server** service that may be used to store arbitrary metadata."
}

variable "kubernetes_service_annotations_spark_driver" {
  type        = map(string)
  default     = null
  description = "(Optional) An unstructured key value map stored with the **anaml_spark_driver** service that may be used to store arbitrary metadata."
}

variable "kubernetes_service_annotations_spark_history_service" {
  type        = map(string)
  default     = null
  description = "(Optional) An unstructured key value map stored with the **anaml_spark_history** service that may be used to store arbitrary metadata."
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


variable "anaml_admin_api_kubernetes_secret_name" {
  type     = string
  nullable = false
  default  = "anaml-server-admin-api-auth"
}
