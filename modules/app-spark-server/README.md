<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.11)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.11)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_config_map.anaml_spark_server_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_config_map.spark_defaults_conf](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.anaml_spark_server_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_deployment.spark_history_server_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_role.spark](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) (resource)
- [kubernetes_role_binding.spark](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) (resource)
- [kubernetes_service.anaml_spark_driver](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_service.anaml_spark_server_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_service.spark_history_server_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_service_account.spark](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

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

### <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host)

Description: n/a

Type: `string`

### <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password)

Description: n/a

Type: `string`

### <a name="input_spark_log_directory"></a> [spark\_log\_directory](#input\_spark\_log\_directory)

Description: The log directory used for spark.eventLodDir and spark.history.fs.logDirectory

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_env_from"></a> [additional\_env\_from](#input\_additional\_env\_from)

Description: n/a

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

### <a name="input_additional_env_values"></a> [additional\_env\_values](#input\_additional\_env\_values)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_additional_volume_mounts"></a> [additional\_volume\_mounts](#input\_additional\_volume\_mounts)

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

### <a name="input_additional_volumes"></a> [additional\_volumes](#input\_additional\_volumes)

Description: n/a

Type:

```hcl
list(object({
    name = string

    secret = optional(object({
      secret_name = string
    }))

    config_map = optional(object({
      name = string
    }))
  }))
```

Default: `[]`

### <a name="input_anaml_admin_api_kubernetes_secret_name"></a> [anaml\_admin\_api\_kubernetes\_secret\_name](#input\_anaml\_admin\_api\_kubernetes\_secret\_name)

Description: n/a

Type: `string`

Default: `"anaml-server-admin-api-auth"`

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

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: (Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)

Type: `string`

Default: `"anaml-spark-server"`

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

### <a name="input_kubernetes_service_annotations_anaml_spark_server"></a> [kubernetes\_service\_annotations\_anaml\_spark\_server](#input\_kubernetes\_service\_annotations\_anaml\_spark\_server)

Description: (Optional) An unstructured key value map stored with the **anaml\_spark\_server** service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_spark_driver"></a> [kubernetes\_service\_annotations\_spark\_driver](#input\_kubernetes\_service\_annotations\_spark\_driver)

Description: (Optional) An unstructured key value map stored with the **anaml\_spark\_driver** service that may be used to store arbitrary metadata.

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

### <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port)

Description: n/a

Type: `number`

Default: `5432`

### <a name="input_spark_config_overrides"></a> [spark\_config\_overrides](#input\_spark\_config\_overrides)

Description: Additional spark config / overrides to merge into spark conf. This is useful for AWS/GCP specfic values

Type: `map(string)`

Default: `{}`

### <a name="input_spark_history_server_additional_env_from"></a> [spark\_history\_server\_additional\_env\_from](#input\_spark\_history\_server\_additional\_env\_from)

Description: n/a

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

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
    }))

    config_map = optional(object({
      name = string
    }))
  }))
```

Default: `[]`

## Outputs

No outputs.
<!-- END_TF_DOCS -->