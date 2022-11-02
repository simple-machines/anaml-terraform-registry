<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.11)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 2.2.1)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (2.15.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_config_map.anaml_spark_history_server_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_config_map.anaml_spark_server_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_config_map.spark_defaults_conf](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.anaml_spark_server_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_deployment.spark_history_server_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_role.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) (resource)
- [kubernetes_role_binding.spark](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) (resource)
- [kubernetes_service.anaml_spark_server_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_service.spark_history_server_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_service_account.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_server_password"></a> [anaml\_server\_password](#input\_anaml\_server\_password)

Description: n/a

Type: `string`

### <a name="input_anaml_server_user"></a> [anaml\_server\_user](#input\_anaml\_server\_user)

Description: n/a

Type: `string`

### <a name="input_anaml_spark_server_version"></a> [anaml\_spark\_server\_version](#input\_anaml\_spark\_server\_version)

Description: n/a

Type: `string`

### <a name="input_checkpoint_location"></a> [checkpoint\_location](#input\_checkpoint\_location)

Description: n/a

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: n/a

Type: `string`

### <a name="input_kubernetes_service_account_spark_driver_executor"></a> [kubernetes\_service\_account\_spark\_driver\_executor](#input\_kubernetes\_service\_account\_spark\_driver\_executor)

Description: Service account used for the spark drivers and executors

Type: `string`

### <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host)

Description: n/a

Type: `string`

### <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password)

Description: n/a

Type: `string`

### <a name="input_postgres_user"></a> [postgres\_user](#input\_postgres\_user)

Description: The user to connect to Postgres as. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGUSER)`.

Type: `string`

### <a name="input_spark_log_directory"></a> [spark\_log\_directory](#input\_spark\_log\_directory)

Description: The log directory used for spark.eventLodDir and spark.history.fs.logDirectory

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_database_name"></a> [anaml\_database\_name](#input\_anaml\_database\_name)

Description: n/a

Type: `string`

Default: `"anaml"`

### <a name="input_anaml_database_schema_name"></a> [anaml\_database\_schema\_name](#input\_anaml\_database\_schema\_name)

Description: n/a

Type: `string`

Default: `"anaml"`

### <a name="input_anaml_server_url"></a> [anaml\_server\_url](#input\_anaml\_server\_url)

Description: n/a

Type: `string`

Default: `"http://anaml-server.anaml.svc.cluster.local:8080"`

### <a name="input_kubernetes_container_spark_history_server_env_from"></a> [kubernetes\_container\_spark\_history\_server\_env\_from](#input\_kubernetes\_container\_spark\_history\_server\_env\_from)

Description: Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret\_ref to use in the `postgres_user` and `postgres_password` values

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

### <a name="input_kubernetes_container_spark_server_env"></a> [kubernetes\_container\_spark\_server\_env](#input\_kubernetes\_container\_spark\_server\_env)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_kubernetes_container_spark_server_env_from"></a> [kubernetes\_container\_spark\_server\_env\_from](#input\_kubernetes\_container\_spark\_server\_env\_from)

Description: Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret\_ref to use in the `postgres_user` and `postgres_password` values

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

### <a name="input_kubernetes_container_spark_server_volume_mounts"></a> [kubernetes\_container\_spark\_server\_volume\_mounts](#input\_kubernetes\_container\_spark\_server\_volume\_mounts)

Description: n/a

Type:

```hcl
list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
```

Default: `[]`

### <a name="input_kubernetes_container_spark_server_volumes"></a> [kubernetes\_container\_spark\_server\_volumes](#input\_kubernetes\_container\_spark\_server\_volumes)

Description: n/a

Type:

```hcl
list(object({
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
```

Default: `[]`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: (Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)

Type: `set(string)`

Default:

```json
[
  "anaml-spark-server"
]
```

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_spark_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

Type: `string`

Default: `null`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: (Optional) Namespace defines the space within which name of the deployment must be unique.

Type: `string`

Default: `null`

### <a name="input_kubernetes_node_selector_app"></a> [kubernetes\_node\_selector\_app](#input\_kubernetes\_node\_selector\_app)

Description: This is the Driver deployment so deploy to the app pool so the expensive spark pool can scale down The driver is configured so workers will use anaml-spark-pool

Type: `map(string)`

Default:

```json
{
  "node_pool": "anaml-app-pool"
}
```

### <a name="input_kubernetes_node_selector_spark_executor"></a> [kubernetes\_node\_selector\_spark\_executor](#input\_kubernetes\_node\_selector\_spark\_executor)

Description: n/a

Type: `map(string)`

Default:

```json
{
  "node_pool": "anaml-spark-pool"
}
```

### <a name="input_kubernetes_pod_sidecars"></a> [kubernetes\_pod\_sidecars](#input\_kubernetes\_pod\_sidecars)

Description: Optional sidecars to provision i.e. Google Cloud SQL Auth Proxy if deploying in GCP

Type:

```hcl
set(
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
```

Default: `[]`

### <a name="input_kubernetes_role_spark_driver_executor_create"></a> [kubernetes\_role\_spark\_driver\_executor\_create](#input\_kubernetes\_role\_spark\_driver\_executor\_create)

Description: If this module should create the specified service account

Type: `bool`

Default: `true`

### <a name="input_kubernetes_role_spark_driver_executor_name"></a> [kubernetes\_role\_spark\_driver\_executor\_name](#input\_kubernetes\_role\_spark\_driver\_executor\_name)

Description: n/a

Type: `string`

Default: `"spark"`

### <a name="input_kubernetes_service_account_deployment"></a> [kubernetes\_service\_account\_deployment](#input\_kubernetes\_service\_account\_deployment)

Description: Service account used for anaml-spark-server and spark-history-server

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_account_spark_driver_executor_annotations"></a> [kubernetes\_service\_account\_spark\_driver\_executor\_annotations](#input\_kubernetes\_service\_account\_spark\_driver\_executor\_annotations)

Description: n/a

Type: `map(any)`

Default: `null`

### <a name="input_kubernetes_service_account_spark_driver_executor_create"></a> [kubernetes\_service\_account\_spark\_driver\_executor\_create](#input\_kubernetes\_service\_account\_spark\_driver\_executor\_create)

Description: If this module should create the specified service account. This should be false if the service account already exists.

Type: `bool`

Default: `true`

### <a name="input_kubernetes_service_annotations_anaml_spark_server"></a> [kubernetes\_service\_annotations\_anaml\_spark\_server](#input\_kubernetes\_service\_annotations\_anaml\_spark\_server)

Description: (Optional) An unstructured key value map stored with the **anaml\_spark\_server** service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_spark_history_service"></a> [kubernetes\_service\_annotations\_spark\_history\_service](#input\_kubernetes\_service\_annotations\_spark\_history\_service)

Description: (Optional) An unstructured key value map stored with the **anaml\_spark\_history** service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

### <a name="input_log4j_overrides"></a> [log4j\_overrides](#input\_log4j\_overrides)

Description: Override log4j default log levels. Format is class.name={debug|error|info|trace|warn}

Type: `map(string)`

Default: `{}`

### <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port)

Description: n/a

Type: `number`

Default: `5432`

### <a name="input_spark_cluster_configs"></a> [spark\_cluster\_configs](#input\_spark\_cluster\_configs)

Description: If you need to generate custom spark cluster pod templates set this value. This function generates '/config/CLUSTER\_NAME-spark-{driver|executor}-template.yaml files in the pod using the given executor/driver template values.

Type:

```hcl
list(object({
    cluster_name          = string
    executor_pod_template = string
    driver_pod_template   = string
  }))
```

Default: `[]`

### <a name="input_spark_config_overrides"></a> [spark\_config\_overrides](#input\_spark\_config\_overrides)

Description: Additional spark config / overrides to merge into spark conf. This is useful for AWS/GCP specfic values

Type: `map(string)`

Default: `{}`

### <a name="input_spark_history_server_additional_env_values"></a> [spark\_history\_server\_additional\_env\_values](#input\_spark\_history\_server\_additional\_env\_values)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_spark_history_server_additional_spark_history_opts"></a> [spark\_history\_server\_additional\_spark\_history\_opts](#input\_spark\_history\_server\_additional\_spark\_history\_opts)

Description: n/a

Type: `list(string)`

Default: `[]`

### <a name="input_spark_history_server_additional_volume_mounts"></a> [spark\_history\_server\_additional\_volume\_mounts](#input\_spark\_history\_server\_additional\_volume\_mounts)

Description: n/a

Type:

```hcl
list(object({
    name       = string
    mount_path = string
    read_only  = bool
  }))
```

Default: `[]`

### <a name="input_spark_history_server_additional_volumes"></a> [spark\_history\_server\_additional\_volumes](#input\_spark\_history\_server\_additional\_volumes)

Description: n/a

Type:

```hcl
list(object({
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
```

Default: `[]`

### <a name="input_spark_history_server_ui_proxy_base"></a> [spark\_history\_server\_ui\_proxy\_base](#input\_spark\_history\_server\_ui\_proxy\_base)

Description: Controls the basepath used in Spark UI history server hyperlinks

Type: `string`

Default: `"/spark-history"`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore)

Description: (Optional) The name of the Kubernetes secret containing a Java pkcs12 keystore if you which to enable client SSL support and or enable HTTPS for anaml-server

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_key)

Description: (Optional) The Java pkcs12 keystore key inside the kubernetes\_secret\_pkcs12\_keystore value

Type: `string`

Default: `"javax.net.ssl.keyStore"`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_password"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_password](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_password)

Description: (Optional) The Kubernetes secret name containing the ssl\_kubernetes\_secret\_pkcs12\_keystore password if the keystore is password protected

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_password_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_password\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_password\_key)

Description: (Optional) The key used inside ssl\_kubernetes\_secret\_pkcs12\_keystore\_password for the trust store password if set

Type: `string`

Default: `"javax.net.ssl.keyStorePassword"`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore)

Description: (Optional) The name of the Kubernetes secret containing a Java pkcs12 truststore if you which to enable client SSL support and or enable HTTPS for anaml-server

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_key)

Description: (Optional) The Java pkcs12 truststore key inside the kubernetes\_secret\_pkcs12\_truststore value

Type: `string`

Default: `"javax.net.ssl.trustStore"`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_password"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_password](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_password)

Description: (Optional) The Kubernetes secret name containing the ssl\_kubernetes\_secret\_pkcs12\_truststore password if the truststore is password protected

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_password_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_password\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_password\_key)

Description: (Optional) The key used inside ssl\_kubernetes\_secret\_pkcs12\_truststore\_password for the trust store password if set

Type: `string`

Default: `"javax.net.ssl.trustStorePassword"`

## Outputs

The following outputs are exported:

### <a name="output_anaml_spark_server_internal_url"></a> [anaml\_spark\_server\_internal\_url](#output\_anaml\_spark\_server\_internal\_url)

Description: n/a

### <a name="output_spark_history_server_internal_url"></a> [spark\_history\_server\_internal\_url](#output\_spark\_history\_server\_internal\_url)

Description: n/a
<!-- END_TF_DOCS -->