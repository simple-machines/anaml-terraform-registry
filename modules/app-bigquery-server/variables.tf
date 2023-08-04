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

variable "kubernetes_node_selector" {
  type        = map(string)
  default     = null
  description = "(Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection)."
  nullable    = true
}

variable "kubernetes_deployment_name" {
  type        = set(string)
  default     = ["anaml-bigquery-server"]
  description = "(Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)"
  nullable    = false

  validation {
    condition     = length(var.kubernetes_deployment_name) > 0
    error_message = "The kubernetes_deployment_name must have at least one value."
  }
}

variable "kubernetes_container_env_from" {
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

variable "kubernetes_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "(Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)"

  validation {
    condition     = contains(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.kubernetes_service_type)
    error_message = "The kubernetes_service_type value must be one of ExternalName, ClusterIP, NodePort or LoadBalancer."
  }
}

variable "anaml_bigquery_server_version" {
  type     = string
  nullable = false
}

variable "container_registry" {
  type     = string
  nullable = false
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

variable "kubernetes_container_env" {
  type = list(object({
    name  = string
    value = string
  }))

  default = []
}

variable "kubernetes_container_volumes" {
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

variable "kubernetes_container_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}

variable "kubernetes_container_resources_requests_cpu" {
  type    = string
  default = null
}

variable "kubernetes_container_resources_requests_memory" {
  type    = string
  default = 256
}

variable "kubernetes_container_resources_limits_cpu" {
  type    = string
  default = null
}

variable "kubernetes_container_resources_limits_memory" {
  type    = string
  default = null
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

variable "kubernetes_container_volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
  default = []
}

variable "kubernetes_service_annotations" {
  type        = map(string)
  default     = null
  description = "(Optional) An unstructured key value map stored with the **anaml_spark_server** service that may be used to store arbitrary metadata."
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
