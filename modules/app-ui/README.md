# anaml-ui Terraform module

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
| [kubernetes_deployment.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_ui_version"></a> [anaml\_ui\_version](#input\_anaml\_ui\_version) | The version of anaml-ui to deploy | `string` | n/a | yes |
| <a name="input_api_url"></a> [api\_url](#input\_api\_url) | n/a | `string` | n/a | yes |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The container registry to use to fetch the anaml-ui container | `string` | n/a | yes |
| <a name="input_docs_url"></a> [docs\_url](#input\_docs\_url) | n/a | `string` | n/a | yes |
| <a name="input_enable_new_functionality"></a> [enable\_new\_functionality](#input\_enable\_new\_functionality) | Enable new-style functionality in the user interface. | `bool` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname to use for UI links | `string` | n/a | yes |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Additional labels to add to Kubernetes deployment | `map(string)` | `{}` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"anaml-ui"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Additional annotations to add to Kubernetes anaml-ui service definition | `map(string)` | `{}` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"NodePort"` | no |
| <a name="input_skin"></a> [skin](#input\_skin) | The skin to use | `string` | `"anaml"` | no |
| <a name="input_spark_history_server_url"></a> [spark\_history\_server\_url](#input\_spark\_history\_server\_url) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->