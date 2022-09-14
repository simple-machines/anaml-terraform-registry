<!-- BEGIN_TF_DOCS -->
# app-all Terraform module

The app-docs Terraform module deploys the full suite of Anaml applications to Kubernetes.
 - [anaml-docs](../app-docs)
 - [anaml-server](../app-server)
 - [anaml-ui](../app-ui)
 - [ingress](../kubernetes-ingress) - Optional Kubernetes Ingress setup. See the [kubernetes\_ingress\_enable](#input\_kubernetes\_ingress\_enable) option below
 - [local-postgres](../postgres) - Optional Postgres Kubernetes stateful set. This is only recommended for dev/test. See the [kubernetes\_service\_enable\_postgres](#input\_kubernetes\_service\_enable\_postgres) option below
 - [spark-server](../app-spark-server)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.11)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.11)

## Modules

The following Modules are called:

### <a name="module_anaml-docs"></a> [anaml-docs](#module\_anaml-docs)

Source: ../app-docs

Version:

### <a name="module_anaml-server"></a> [anaml-server](#module\_anaml-server)

Source: ../app-server

Version:

### <a name="module_anaml-ui"></a> [anaml-ui](#module\_anaml-ui)

Source: ../app-ui

Version:

### <a name="module_ingress"></a> [ingress](#module\_ingress)

Source: ../kubernetes-ingress

Version:

### <a name="module_local-postgres"></a> [local-postgres](#module\_local-postgres)

Source: ../postgres

Version:

### <a name="module_spark-server"></a> [spark-server](#module\_spark-server)

Source: ../app-spark-server

Version:

## Resources

The following resources are used by this module:

- [kubernetes_namespace.anaml_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) (resource)
- [kubernetes_secret.postgres_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_service_account.anaml](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_version"></a> [anaml\_version](#input\_anaml\_version)

Description: Anaml version to deploy. This should be a valid Anaml container tag

Type: `string`

### <a name="input_hostname"></a> [hostname](#input\_hostname)

Description: The hostname Anaml will be accessed from. i.e 'dev.nonprod.anaml.app'

Type: `string`

### <a name="input_kubernetes_namespace_name"></a> [kubernetes\_namespace\_name](#input\_kubernetes\_namespace\_name)

Description: Kubernetes namespace to deploy to. This should be set if create\_anaml\_namespace is false

Type: `string`

### <a name="input_override_anaml_spark_server_checkpoint_location"></a> [override\_anaml\_spark\_server\_checkpoint\_location](#input\_override\_anaml\_spark\_server\_checkpoint\_location)

Description: n/a

Type: `string`

### <a name="input_override_anaml_spark_server_spark_log_directory"></a> [override\_anaml\_spark\_server\_spark\_log\_directory](#input\_override\_anaml\_spark\_server\_spark\_log\_directory)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_admin_email"></a> [anaml\_admin\_email](#input\_anaml\_admin\_email)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_anaml_admin_password"></a> [anaml\_admin\_password](#input\_anaml\_admin\_password)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_anaml_admin_secret"></a> [anaml\_admin\_secret](#input\_anaml\_admin\_secret)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_anaml_admin_token"></a> [anaml\_admin\_token](#input\_anaml\_admin\_token)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: n/a

Type: `string`

Default: `"australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"`

### <a name="input_enable_form_client"></a> [enable\_form\_client](#input\_enable\_form\_client)

Description: Enable Login form

Type: `bool`

Default: `false`

### <a name="input_https_urls"></a> [https\_urls](#input\_https\_urls)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_kubernetes_container_env_from_anaml_server"></a> [kubernetes\_container\_env\_from\_anaml\_server](#input\_kubernetes\_container\_env\_from\_anaml\_server)

Description: Inject additional `env_from` values in to the anaml\_server deployment

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

### <a name="input_kubernetes_ingress_enable"></a> [kubernetes\_ingress\_enable](#input\_kubernetes\_ingress\_enable)

Description: If true, deploy an ingress for Anaml

Type: `bool`

Default: `false`

### <a name="input_kubernetes_ingress_hostname"></a> [kubernetes\_ingress\_hostname](#input\_kubernetes\_ingress\_hostname)

Description: Optional hostname to use for the Anaml ingress definition when kubernetes\_ingress\_enable is true

Type: `string`

Default: `null`

### <a name="input_kubernetes_ingress_name"></a> [kubernetes\_ingress\_name](#input\_kubernetes\_ingress\_name)

Description: The name to use for the Anaml ingress definition

Type: `string`

Default: `"anaml"`

### <a name="input_kubernetes_namespace_create"></a> [kubernetes\_namespace\_create](#input\_kubernetes\_namespace\_create)

Description: If the given namespace should be created as part of this deployment

Type: `bool`

Default: `false`

### <a name="input_kubernetes_persistent_volume_claim_storage_class_name_postgres"></a> [kubernetes\_persistent\_volume\_claim\_storage\_class\_name\_postgres](#input\_kubernetes\_persistent\_volume\_claim\_storage\_class\_name\_postgres)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_pod_anaml_server_sidecars"></a> [kubernetes\_pod\_anaml\_server\_sidecars](#input\_kubernetes\_pod\_anaml\_server\_sidecars)

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

### <a name="input_kubernetes_pod_anaml_spark_server_sidecars"></a> [kubernetes\_pod\_anaml\_spark\_server\_sidecars](#input\_kubernetes\_pod\_anaml\_spark\_server\_sidecars)

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

### <a name="input_kubernetes_pod_node_selector_app"></a> [kubernetes\_pod\_node\_selector\_app](#input\_kubernetes\_pod\_node\_selector\_app)

Description: (Optional) NodeSelector is a selector which must be true for the **apps** pod's to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_pod_node_selector_postgres"></a> [kubernetes\_pod\_node\_selector\_postgres](#input\_kubernetes\_pod\_node\_selector\_postgres)

Description: (Optional) NodeSelector is a selector which must be true for the **postgres** pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_pod_node_selector_spark_executor"></a> [kubernetes\_pod\_node\_selector\_spark\_executor](#input\_kubernetes\_pod\_node\_selector\_spark\_executor)

Description: (Optional) NodeSelector is a selector which must be true for the **spark\_executor** pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_account_annotations"></a> [kubernetes\_service\_account\_annotations](#input\_kubernetes\_service\_account\_annotations)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_service_account_create"></a> [kubernetes\_service\_account\_create](#input\_kubernetes\_service\_account\_create)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_annotations_anaml_docs"></a> [kubernetes\_service\_annotations\_anaml\_docs](#input\_kubernetes\_service\_annotations\_anaml\_docs)

Description: Kubernetes service annotations to set if any for anaml-docs

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_anaml_server"></a> [kubernetes\_service\_annotations\_anaml\_server](#input\_kubernetes\_service\_annotations\_anaml\_server)

Description: Optional Kubernetes service annotations to set for anaml-server

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_anaml_spark_server"></a> [kubernetes\_service\_annotations\_anaml\_spark\_server](#input\_kubernetes\_service\_annotations\_anaml\_spark\_server)

Description: Kubernetes service annotations to set if any

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_anaml_ui"></a> [kubernetes\_service\_annotations\_anaml\_ui](#input\_kubernetes\_service\_annotations\_anaml\_ui)

Description: Optional Kubernetes service annotations to set for anaml-ui

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_postgres"></a> [kubernetes\_service\_annotations\_postgres](#input\_kubernetes\_service\_annotations\_postgres)

Description: Optional Kubernetes service annotations to set for Postgres

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_spark_driver"></a> [kubernetes\_service\_annotations\_spark\_driver](#input\_kubernetes\_service\_annotations\_spark\_driver)

Description: Kubernetes service annotations to set if any

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations_spark_history_service"></a> [kubernetes\_service\_annotations\_spark\_history\_service](#input\_kubernetes\_service\_annotations\_spark\_history\_service)

Description: Kubernetes service annotations to set if any

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_enable_postgres"></a> [kubernetes\_service\_enable\_postgres](#input\_kubernetes\_service\_enable\_postgres)

Description: If true, deploy a Postgres pod for Anaml to use. If false you should provide the Postgres host details

Type: `bool`

Default: `false`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: The Kubernetes service type to use. Valid values are ClusterIP, ExternalName, LoadBalancer or NodeIP

Type: `string`

Default: `"ClusterIP"`

### <a name="input_license_key"></a> [license\_key](#input\_license\_key)

Description: Your ANAML license key. If the license key is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(ANAML_LICENSE_KEY)`.

Type: `string`

Default: `null`

### <a name="input_oidc_additional_scopes"></a> [oidc\_additional\_scopes](#input\_oidc\_additional\_scopes)

Description: OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method.

Type: `list(string)`

Default: `[]`

### <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id)

Description: OpenID Connect client identifier. Required when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_oidc_client_secret"></a> [oidc\_client\_secret](#input\_oidc\_client\_secret)

Description: OpenID Connect client secret. Required when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_oidc_discovery_uri"></a> [oidc\_discovery\_uri](#input\_oidc\_discovery\_uri)

Description: OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_oidc_enable"></a> [oidc\_enable](#input\_oidc\_enable)

Description: Enable OpenID Connect login

Type: `bool`

Default: `false`

### <a name="input_oidc_permitted_users_group_id"></a> [oidc\_permitted\_users\_group\_id](#input\_oidc\_permitted\_users\_group\_id)

Description: OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_oidc_tenant_id"></a> [oidc\_tenant\_id](#input\_oidc\_tenant\_id)

Description: OpenID Connect tenant identifier. Required when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_override_anaml_docs_version"></a> [override\_anaml\_docs\_version](#input\_override\_anaml\_docs\_version)

Description: anaml-docs version override. This value should contain the container tag to deploy

Type: `string`

Default: `null`

### <a name="input_override_anaml_server_anaml_database_schema_name"></a> [override\_anaml\_server\_anaml\_database\_schema\_name](#input\_override\_anaml\_server\_anaml\_database\_schema\_name)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_override_anaml_server_governance_run_type_checks"></a> [override\_anaml\_server\_governance\_run\_type\_checks](#input\_override\_anaml\_server\_governance\_run\_type\_checks)

Description: n/a

Type: `bool`

Default: `null`

### <a name="input_override_anaml_server_java_opts"></a> [override\_anaml\_server\_java\_opts](#input\_override\_anaml\_server\_java\_opts)

Description: anaml\_server override\_java\_opts value. Provide additional JAVA\_OPTS values to anaml\_server

Type: `list(string)`

Default: `[]`

### <a name="input_override_anaml_server_version"></a> [override\_anaml\_server\_version](#input\_override\_anaml\_server\_version)

Description: anaml-server version override. This value should contain the container tag to deploy

Type: `string`

Default: `null`

### <a name="input_override_anaml_spark_server_additional_env_values"></a> [override\_anaml\_spark\_server\_additional\_env\_values](#input\_override\_anaml\_spark\_server\_additional\_env\_values)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_override_anaml_spark_server_additional_spark_driver_pod_templates"></a> [override\_anaml\_spark\_server\_additional\_spark\_driver\_pod\_templates](#input\_override\_anaml\_spark\_server\_additional\_spark\_driver\_pod\_templates)

Description: n/a

Type:

```hcl
map(
    object({
      tolerations = set(
        object({
          key      = string
          operator = string
          effect   = string
        })
      )
    })
  )
```

Default: `null`

### <a name="input_override_anaml_spark_server_additional_spark_executor_pod_templates"></a> [override\_anaml\_spark\_server\_additional\_spark\_executor\_pod\_templates](#input\_override\_anaml\_spark\_server\_additional\_spark\_executor\_pod\_templates)

Description: n/a

Type:

```hcl
map(
    object({
      tolerations = set(
        object({
          key      = string
          operator = string
          effect   = string
        })
      )
    })
  )
```

Default: `null`

### <a name="input_override_anaml_spark_server_additional_volume_mounts"></a> [override\_anaml\_spark\_server\_additional\_volume\_mounts](#input\_override\_anaml\_spark\_server\_additional\_volume\_mounts)

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

### <a name="input_override_anaml_spark_server_additional_volumes"></a> [override\_anaml\_spark\_server\_additional\_volumes](#input\_override\_anaml\_spark\_server\_additional\_volumes)

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

### <a name="input_override_anaml_spark_server_spark_config_overrides"></a> [override\_anaml\_spark\_server\_spark\_config\_overrides](#input\_override\_anaml\_spark\_server\_spark\_config\_overrides)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_override_anaml_spark_server_version"></a> [override\_anaml\_spark\_server\_version](#input\_override\_anaml\_spark\_server\_version)

Description: anaml-spark-server version override. This value should contain the container tag to deploy

Type: `string`

Default: `null`

### <a name="input_override_anaml_ui_api_url"></a> [override\_anaml\_ui\_api\_url](#input\_override\_anaml\_ui\_api\_url)

Description: anaml-ui api\_url override

Type: `string`

Default: `null`

### <a name="input_override_anaml_ui_skin"></a> [override\_anaml\_ui\_skin](#input\_override\_anaml\_ui\_skin)

Description: anaml-ui skin override

Type: `string`

Default: `"anaml"`

### <a name="input_override_anaml_ui_version"></a> [override\_anaml\_ui\_version](#input\_override\_anaml\_ui\_version)

Description: anaml-ui version override. This value should contain the container tag to deploy

Type: `string`

Default: `null`

### <a name="input_override_spark_history_server_additional_env_values"></a> [override\_spark\_history\_server\_additional\_env\_values](#input\_override\_spark\_history\_server\_additional\_env\_values)

Description: n/a

Type:

```hcl
list(object({
    name  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_override_spark_history_server_additional_volume_mounts"></a> [override\_spark\_history\_server\_additional\_volume\_mounts](#input\_override\_spark\_history\_server\_additional\_volume\_mounts)

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

### <a name="input_override_spark_history_server_additional_volumes"></a> [override\_spark\_history\_server\_additional\_volumes](#input\_override\_spark\_history\_server\_additional\_volumes)

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

### <a name="input_override_spark_history_server_ui_proxy_base"></a> [override\_spark\_history\_server\_ui\_proxy\_base](#input\_override\_spark\_history\_server\_ui\_proxy\_base)

Description: Override the Spark UI `spark.ui.proxyBase` value. Generally you should not set this value and prefer the `ui_base_path` option which sets the basepath across all apps

Type: `string`

Default: `null`

### <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host)

Description: The postgres host to use if kubernetes\_service\_enable\_postgres if false and using an external postgres database

Type: `string`

Default: `null`

### <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password)

Description: The pstgress user password to connect to remote DB. If kubernetes\_service\_enable\_porstgres is true this value is used to set the local postgres password

Type: `string`

Default: `null`

### <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port)

Description: n/a

Type: `number`

Default: `5432`

### <a name="input_postgres_user"></a> [postgres\_user](#input\_postgres\_user)

Description: The postgres user to use if kubernetes\_service\_enable\_postgres if false and using an external postgres database

Type: `string`

Default: `"anaml"`

### <a name="input_ui_base_path"></a> [ui\_base\_path](#input\_ui\_base\_path)

Description: Set the application basepath if running on a path other than `/`. Useful if using pathbased routing and not host based routing

Type: `string`

Default: `"/"`

## Outputs

The following outputs are exported:

### <a name="output_anaml_api_url"></a> [anaml\_api\_url](#output\_anaml\_api\_url)

Description: n/a

### <a name="output_kubernetes_service_account"></a> [kubernetes\_service\_account](#output\_kubernetes\_service\_account)

Description: The Kubernetes service account used for deployments

### <a name="output_kubernetes_service_name_anaml_server"></a> [kubernetes\_service\_name\_anaml\_server](#output\_kubernetes\_service\_name\_anaml\_server)

Description: n/a
<!-- END_TF_DOCS -->