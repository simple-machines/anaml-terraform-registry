<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.11)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 2.2.1)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.11)

- <a name="provider_random"></a> [random](#provider\_random) (>= 2.2.1)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_deployment.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.anaml_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [random_uuid.deployment_instance](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_server_url"></a> [anaml\_server\_url](#input\_anaml\_server\_url)

Description: n/a

Type: `string`

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

### <a name="input_spark_history_server_url"></a> [spark\_history\_server\_url](#input\_spark\_history\_server\_url)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_basepath"></a> [basepath](#input\_basepath)

Description: The root path used for UI ingress, defaults to '/'. You will need to change this if running the UI on a subpath

Type: `string`

Default: `"/"`

### <a name="input_enable_new_functionality"></a> [enable\_new\_functionality](#input\_enable\_new\_functionality)

Description: Enable new-style functionality in the user interface.

Type: `bool`

Default: `true`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Additional labels to add to Kubernetes deployment

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: (Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)

Type: `string`

Default: `"anaml-ui"`

### <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas)

Description: (Optional) The number of desired replicas. This attribute is a string to be able to distinguish between explicit zero and not specified. Defaults to 1. For more info see [Kubernetes reference](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)

Type: `string`

Default: `"1"`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_ui_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

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

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: (Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

### <a name="input_skin"></a> [skin](#input\_skin)

Description: The skin to use

Type: `string`

Default: `"anaml"`

## Outputs

The following outputs are exported:

### <a name="output_internal_url"></a> [internal\_url](#output\_internal\_url)

Description: n/a

### <a name="output_kubernetes_service_name"></a> [kubernetes\_service\_name](#output\_kubernetes\_service\_name)

Description: n/a

### <a name="output_kubernetes_service_port_name"></a> [kubernetes\_service\_port\_name](#output\_kubernetes\_service\_port\_name)

Description: n/a

### <a name="output_kubernetes_service_port_number"></a> [kubernetes\_service\_port\_number](#output\_kubernetes\_service\_port\_number)

Description: n/a
<!-- END_TF_DOCS -->