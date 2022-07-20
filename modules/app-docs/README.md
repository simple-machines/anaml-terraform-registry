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

- [kubernetes_deployment.anaml_docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.anaml_docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_docs_version"></a> [anaml\_docs\_version](#input\_anaml\_docs\_version)

Description: The version of anaml-docs to deploy

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-docs container

Type: `string`

### <a name="input_hostname"></a> [hostname](#input\_hostname)

Description: The hostname to use for UI links

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: n/a

Type: `string`

Default: `"anaml-docs"`

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

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: Kubernetes service annotations to set if any

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: n/a

Type: `string`

Default: `"ClusterIP"`

## Outputs

No outputs.

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
| [kubernetes_deployment.anaml_docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.anaml_docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_docs_version"></a> [anaml\_docs\_version](#input\_anaml\_docs\_version) | The version of anaml-docs to deploy | `string` | n/a | yes |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The container registry to use to fetch the anaml-docs container | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname to use for UI links | `string` | n/a | yes |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Kubernetes labels to set if any. These values will be merged with the defaults | `map(string)` | `null` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"anaml-docs"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Kubernetes service annotations to set if any | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"ClusterIP"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->