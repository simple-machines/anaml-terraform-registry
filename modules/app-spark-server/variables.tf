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
  type        = set(string)
  default     = ["anaml-spark-server"]
  description = "(Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)"
  nullable    = false

  validation {
    condition     = length(var.kubernetes_deployment_name) > 0
    error_message = "The kubernetes_deployment_name must have at least one value."
  }
}

variable "kubernetes_container_spark_server_env_from" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))
  description = "Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret_ref to use in the `postgres_user` and `postgres_password` values"
  default     = []
}

variable "kubernetes_container_spark_history_server_env_from" {
  type = list(object({
    secret_ref = object({
      name = string
    })
  }))
  description = "Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret_ref to use in the `postgres_user` and `postgres_password` values"
  default     = []
}

variable "kubernetes_image_pull_policy" {
  type        = string
  description = " (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_spark_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)"
  default     = null

  validation {
    condition     = var.kubernetes_image_pull_policy == null ? true : contains(["Always", "Never", "IfNotPresent"], var.kubernetes_image_pull_policy)
    error_message = "The kubernetes_image_pull_policy value must be one of Always, Nerver or IfNotPresent."
  }
}

variable "kubernetes_service_account_deployment" {
  type        = string
  default     = null
  description = "Service account used for anaml-spark-server and spark-history-server"
}

variable "kubernetes_service_account_spark_driver_executor" {
  type        = string
  description = "Service account used for the spark drivers and executors"
}

variable "kubernetes_service_account_spark_driver_executor_create" {
  type        = bool
  default     = true
  description = "If this module should create the specified service account. This should be false if the service account already exists."
}

variable "kubernetes_role_spark_driver_executor_create" {
  type        = bool
  default     = true
  description = "If this module should create the specified service account"
}

variable "kubernetes_role_spark_driver_executor_name" {
  type    = string
  default = "spark"
}

variable "kubernetes_service_account_spark_driver_executor_annotations" {
  type    = map(any)
  default = null
}

variable "kubernetes_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition     = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer."
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
  nullable    = true
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

variable "enable_spark_history_server" {
  type    = bool
  default = true
}

variable "kubernetes_container_spark_server_env" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "kubernetes_container_spark_server_volumes" {
  type = list(object({
    name = string

    secret = optional(object({
      secret_name = string
      items = optional(
        list(
          object({
            key  = optional(string)
            mode = optional(string)
            path = optional(string)
          })
        )
      )
    }))

    config_map = optional(object({
      name = string
    }))
  }))

  default = []
}

variable "kubernetes_container_spark_server_volume_mounts" {
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
      items = optional(
        list(
          object({
            key  = optional(string)
            mode = optional(string)
            path = optional(string)
          })
        )
      )
    }))

    config_map = optional(object({
      name = string
    }))
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

variable "spark_history_server_additional_spark_history_opts" {
  type     = list(string)
  default  = []
  nullable = false
}

variable "spark_history_server_ui_proxy_base" {
  type        = string
  default     = "/spark-history"
  description = "Controls the basepath used in Spark UI history server hyperlinks"
  nullable    = false
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

variable "postgres_user" {
  type        = string
  description = "The user to connect to Postgres as. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGUSER)`."
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

variable "spark_cluster_configs" {
  type = list(object({
    cluster_name          = string
    executor_pod_template = string
    driver_pod_template   = string
  }))
  default     = []
  nullable    = false
  description = "If you need to generate custom spark cluster pod templates set this value. This function generates '/config/CLUSTER_NAME-spark-{driver|executor}-template.yaml files in the pod using the given executor/driver template values."
}

variable "log4j_overrides" {
  type     = map(string)
  default  = {}
  nullable = false

  description = "Override log4j default log levels. Format is class.name={debug|error|info|trace|warn}"

  validation {
    condition     = alltrue([for k, v in var.log4j_overrides : contains(["debug", "error", "info", "trace", "warn"], v)])
    error_message = "Value is not a valid log level. Must be one of debug, error, info, trace, warn."
  }
}

variable "ssl_kubernetes_secret_pkcs12_truststore" {
  type        = string
  default     = null
  description = "(Optional) The name of the Kubernetes secret containing a Java pkcs12 truststore if you which to enable client SSL support and or enable HTTPS for anaml-server"
}

variable "ssl_kubernetes_secret_pkcs12_truststore_key" {
  type        = string
  default     = "javax.net.ssl.trustStore"
  description = "(Optional) The Java pkcs12 truststore key inside the kubernetes_secret_pkcs12_truststore value"
  nullable    = false
}

variable "ssl_kubernetes_secret_pkcs12_truststore_password" {
  type        = string
  default     = null
  description = "(Optional) The Kubernetes secret name containing the ssl_kubernetes_secret_pkcs12_truststore password if the truststore is password protected"
}

variable "ssl_kubernetes_secret_pkcs12_truststore_password_key" {
  type        = string
  default     = "javax.net.ssl.trustStorePassword"
  description = "(Optional) The key used inside ssl_kubernetes_secret_pkcs12_truststore_password for the trust store password if set"
  nullable    = false
}

variable "ssl_kubernetes_secret_pkcs12_keystore" {
  type        = string
  default     = null
  description = "(Optional) The name of the Kubernetes secret containing a Java pkcs12 keystore if you which to enable client SSL support and or enable HTTPS for anaml-server"
}

variable "ssl_kubernetes_secret_pkcs12_keystore_key" {
  type        = string
  default     = "javax.net.ssl.keyStore"
  description = "(Optional) The Java pkcs12 keystore key inside the kubernetes_secret_pkcs12_keystore value"
  nullable    = false
}

variable "ssl_kubernetes_secret_pkcs12_keystore_password" {
  type        = string
  default     = null
  description = "(Optional) The Kubernetes secret name containing the ssl_kubernetes_secret_pkcs12_keystore password if the keystore is password protected"
}

variable "ssl_kubernetes_secret_pkcs12_keystore_password_key" {
  type        = string
  default     = "javax.net.ssl.keyStorePassword"
  description = "(Optional) The key used inside ssl_kubernetes_secret_pkcs12_keystore_password for the trust store password if set"
  nullable    = false
}
