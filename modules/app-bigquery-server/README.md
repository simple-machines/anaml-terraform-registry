<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.11)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 2.2.1)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.11)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_config_map.anaml_bigquery_server_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.anaml_bigquery_server_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.anaml_bigquery_server_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_bigquery_server_version"></a> [anaml\_bigquery\_server\_version](#input\_anaml\_bigquery\_server\_version)

Description: n/a

Type: `string`

### <a name="input_anaml_server_password"></a> [anaml\_server\_password](#input\_anaml\_server\_password)

Description: n/a

Type: `string`

### <a name="input_anaml_server_user"></a> [anaml\_server\_user](#input\_anaml\_server\_user)

Description: n/a

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_server_url"></a> [anaml\_server\_url](#input\_anaml\_server\_url)

Description: n/a

Type: `string`

Default: `"http://anaml-server.anaml.svc.cluster.local:8080"`

### <a name="input_kubernetes_container_env"></a> [kubernetes\_container\_env](#input\_kubernetes\_container\_env)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_kubernetes_container_env_from"></a> [kubernetes\_container\_env\_from](#input\_kubernetes\_container\_env\_from)

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

### <a name="input_kubernetes_container_mounts"></a> [kubernetes\_container\_mounts](#input\_kubernetes\_container\_mounts)

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

### <a name="input_kubernetes_container_resources_limits_cpu"></a> [kubernetes\_container\_resources\_limits\_cpu](#input\_kubernetes\_container\_resources\_limits\_cpu)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_container_resources_limits_memory"></a> [kubernetes\_container\_resources\_limits\_memory](#input\_kubernetes\_container\_resources\_limits\_memory)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_container_resources_requests_cpu"></a> [kubernetes\_container\_resources\_requests\_cpu](#input\_kubernetes\_container\_resources\_requests\_cpu)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_container_resources_requests_memory"></a> [kubernetes\_container\_resources\_requests\_memory](#input\_kubernetes\_container\_resources\_requests\_memory)

Description: n/a

Type: `string`

Default: `256`

### <a name="input_kubernetes_container_volume_mounts"></a> [kubernetes\_container\_volume\_mounts](#input\_kubernetes\_container\_volume\_mounts)

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

### <a name="input_kubernetes_container_volumes"></a> [kubernetes\_container\_volumes](#input\_kubernetes\_container\_volumes)

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
  "anaml-bigquery-server"
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

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: (Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

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

### <a name="input_kubernetes_service_account_deployment"></a> [kubernetes\_service\_account\_deployment](#input\_kubernetes\_service\_account\_deployment)

Description: Service account used for anaml-spark-server and spark-history-server

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: (Optional) An unstructured key value map stored with the **anaml\_spark\_server** service that may be used to store arbitrary metadata.

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

No outputs.
<!-- END_TF_DOCS -->