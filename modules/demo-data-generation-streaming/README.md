<!-- BEGIN_TF_DOCS -->
# demo-streaming-data-generation

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

- [kubernetes_config_map.producer_demo_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.kafka_data_generator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_persistent_volume_claim.data_generation_volume](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_producer_demo_version"></a> [anaml\_producer\_demo\_version](#input\_anaml\_producer\_demo\_version)

Description: The version of anaml-demo-setup container image to deploy

Type: `string`

### <a name="input_customer_source_path"></a> [customer\_source\_path](#input\_customer\_source\_path)

Description: n/a

Type: `string`

### <a name="input_google_bucket"></a> [google\_bucket](#input\_google\_bucket)

Description: n/a

Type: `string`

### <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id)

Description: n/a

Type: `string`

### <a name="input_kafka_bootstrap_servers"></a> [kafka\_bootstrap\_servers](#input\_kafka\_bootstrap\_servers)

Description: n/a

Type: `string`

### <a name="input_kafka_schema_registry_url"></a> [kafka\_schema\_registry\_url](#input\_kafka\_schema\_registry\_url)

Description: n/a

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-docs container

Type: `string`

Default: `"australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"`

### <a name="input_kafka_additional_config"></a> [kafka\_additional\_config](#input\_kafka\_additional\_config)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

Type: `string`

Default: `null`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: (Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: n/a

Type: `string`

Default: `null`

## Outputs

No outputs.
<!-- END_TF_DOCS -->