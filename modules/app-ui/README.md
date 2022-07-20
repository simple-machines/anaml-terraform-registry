# anaml-ui Terraform module

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

- [kubernetes_deployment.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_ui_version"></a> [anaml\_ui\_version](#input\_anaml\_ui\_version)

Description: The version of anaml-ui to deploy

Type: `string`

### <a name="input_api_url"></a> [api\_url](#input\_api\_url)

Description: n/a

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-ui container

Type: `string`

### <a name="input_docs_url"></a> [docs\_url](#input\_docs\_url)

Description: n/a

Type: `string`

### <a name="input_hostname"></a> [hostname](#input\_hostname)

Description: The hostname to use for UI links

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

### <a name="input_spark_history_server_url"></a> [spark\_history\_server\_url](#input\_spark\_history\_server\_url)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_new_functionality"></a> [enable\_new\_functionality](#input\_enable\_new\_functionality)

Description: Enable new-style functionality in the user interface.

Type: `bool`

Default: `true`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Additional labels to add to Kubernetes deployment

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: n/a

Type: `string`

Default: `"anaml-ui"`

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

Description: Additional annotations to add to Kubernetes anaml-ui service definition

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: n/a

Type: `string`

Default: `"NodePort"`

### <a name="input_skin"></a> [skin](#input\_skin)

Description: The skin to use

Type: `string`

Default: `"anaml"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->