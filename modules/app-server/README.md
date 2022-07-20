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

- [kubernetes_config_map.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_secret.anaml_server_admin_api_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_secret.anaml_server_admin_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_service.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_external_domain"></a> [anaml\_external\_domain](#input\_anaml\_external\_domain)

Description: The hostname to use for UI links

Type: `string`

### <a name="input_anaml_server_version"></a> [anaml\_server\_version](#input\_anaml\_server\_version)

Description: The version of anaml-server to deploy

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-server container

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

### <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_admin_email"></a> [anaml\_admin\_email](#input\_anaml\_admin\_email)

Description: If enable\_form\_client is true, the admin account email address for sign in

Type: `string`

Default: `null`

### <a name="input_anaml_admin_password"></a> [anaml\_admin\_password](#input\_anaml\_admin\_password)

Description: If enable\_form\_client is true, the initial admin account password for sign in

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

### <a name="input_anaml_database_name"></a> [anaml\_database\_name](#input\_anaml\_database\_name)

Description: The name of the PostgreSQL database to use for the Anaml Server.

Type: `string`

Default: `"anaml"`

### <a name="input_anaml_database_schema_name"></a> [anaml\_database\_schema\_name](#input\_anaml\_database\_schema\_name)

Description: The name of the PostgreSQL schema to use for the Anaml server.

Type: `string`

Default: `"anaml"`

### <a name="input_enable_form_client"></a> [enable\_form\_client](#input\_enable\_form\_client)

Description: Enable Login form

Type: `bool`

Default: `false`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Additional labels to add to Kubernetes deployment

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: n/a

Type: `string`

Default: `"anaml-server"`

### <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description: n/a

Type: `string`

Default: `"IfNotPresent"`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: n/a

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

### <a name="input_kubernetes_secret_refs"></a> [kubernetes\_secret\_refs](#input\_kubernetes\_secret\_refs)

Description: n/a

Type: `set(string)`

Default: `[]`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: Additional annotations to add to Kubernetes anaml-server service definition

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: n/a

Type: `string`

Default: `"NodePort"`

### <a name="input_oidc_additional_scopes"></a> [oidc\_additional\_scopes](#input\_oidc\_additional\_scopes)

Description: OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method.

Type: `set(string)`

Default: `[]`

### <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_oidc_client_secret"></a> [oidc\_client\_secret](#input\_oidc\_client\_secret)

Description: n/a

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

### <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port)

Description: n/a

Type: `number`

Default: `"5432"`

### <a name="input_postgres_user"></a> [postgres\_user](#input\_postgres\_user)

Description: n/a

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_anaml_admin_api_kubernetes_secret_name"></a> [anaml\_admin\_api\_kubernetes\_secret\_name](#output\_anaml\_admin\_api\_kubernetes\_secret\_name)

Description: n/a

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.anaml_server_admin_api_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.anaml_server_admin_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_admin_email"></a> [anaml\_admin\_email](#input\_anaml\_admin\_email) | If enable\_form\_client is true, the admin account email address for sign in | `string` | `null` | no |
| <a name="input_anaml_admin_password"></a> [anaml\_admin\_password](#input\_anaml\_admin\_password) | If enable\_form\_client is true, the initial admin account password for sign in | `string` | `null` | no |
| <a name="input_anaml_admin_secret"></a> [anaml\_admin\_secret](#input\_anaml\_admin\_secret) | n/a | `string` | `null` | no |
| <a name="input_anaml_admin_token"></a> [anaml\_admin\_token](#input\_anaml\_admin\_token) | n/a | `string` | `null` | no |
| <a name="input_anaml_database_name"></a> [anaml\_database\_name](#input\_anaml\_database\_name) | The name of the PostgreSQL database to use for the Anaml Server. | `string` | `"anaml"` | no |
| <a name="input_anaml_database_schema_name"></a> [anaml\_database\_schema\_name](#input\_anaml\_database\_schema\_name) | The name of the PostgreSQL schema to use for the Anaml server. | `string` | `"anaml"` | no |
| <a name="input_anaml_external_domain"></a> [anaml\_external\_domain](#input\_anaml\_external\_domain) | The hostname to use for UI links | `string` | n/a | yes |
| <a name="input_anaml_server_version"></a> [anaml\_server\_version](#input\_anaml\_server\_version) | The version of anaml-server to deploy | `string` | n/a | yes |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The container registry to use to fetch the anaml-server container | `string` | n/a | yes |
| <a name="input_enable_form_client"></a> [enable\_form\_client](#input\_enable\_form\_client) | Enable Login form | `bool` | `false` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Additional labels to add to Kubernetes deployment | `map(string)` | `{}` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"anaml-server"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_pod_sidecars"></a> [kubernetes\_pod\_sidecars](#input\_kubernetes\_pod\_sidecars) | Optional sidecars to provision i.e. Google Cloud SQL Auth Proxy if deploying in GCP | <pre>set(<br>    object({<br>      name              = string,<br>      image             = string,<br>      image_pull_policy = optional(string), # Optional<br><br>      command = optional(list(string))<br><br>      env = optional(list(object({<br>        name  = string,<br>        value = string,<br>      })))<br><br>      env_from = optional(list(object({<br>        config_map_ref = object({ name = string })<br>        secret_ref     = object({ name = string })<br>      })))<br><br>      volume_mount = optional(list(object({<br>        name       = string,<br>        mount_path = string,<br>        read_only  = bool<br>      })))<br><br>      security_context = optional(object({<br>        run_as_non_root = optional(bool)<br>        run_as_group    = optional(number)<br>        run_as_user     = optional(number)<br>      }))<br><br>      port = optional(object({<br>        container_port = number<br>      }))<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_kubernetes_secret_refs"></a> [kubernetes\_secret\_refs](#input\_kubernetes\_secret\_refs) | n/a | `set(string)` | `[]` | no |
| <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name) | n/a | `string` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Additional annotations to add to Kubernetes anaml-server service definition | `map(string)` | `{}` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"NodePort"` | no |
| <a name="input_oidc_additional_scopes"></a> [oidc\_additional\_scopes](#input\_oidc\_additional\_scopes) | OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method. | `set(string)` | `[]` | no |
| <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id) | n/a | `string` | `null` | no |
| <a name="input_oidc_client_secret"></a> [oidc\_client\_secret](#input\_oidc\_client\_secret) | n/a | `string` | `null` | no |
| <a name="input_oidc_discovery_uri"></a> [oidc\_discovery\_uri](#input\_oidc\_discovery\_uri) | OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method. | `string` | `null` | no |
| <a name="input_oidc_enable"></a> [oidc\_enable](#input\_oidc\_enable) | Enable OpenID Connect login | `bool` | `false` | no |
| <a name="input_oidc_permitted_users_group_id"></a> [oidc\_permitted\_users\_group\_id](#input\_oidc\_permitted\_users\_group\_id) | OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method. | `string` | `null` | no |
| <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host) | n/a | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | n/a | `string` | `null` | no |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | n/a | `number` | `"5432"` | no |
| <a name="input_postgres_user"></a> [postgres\_user](#input\_postgres\_user) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anaml_admin_api_kubernetes_secret_name"></a> [anaml\_admin\_api\_kubernetes\_secret\_name](#output\_anaml\_admin\_api\_kubernetes\_secret\_name) | n/a |
| <a name="output_anaml_api_url"></a> [anaml\_api\_url](#output\_anaml\_api\_url) | n/a |
<!-- END_TF_DOCS -->