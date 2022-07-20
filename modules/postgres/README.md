<!-- BEGIN_TF_DOCS -->
# Postgres Kubernetes stateful set deployment

> :warning: This module should be used for non production deployments and testing only.

We recommend production deployments use AWS RDS or Google Cloud SQL instead of self managing PostgreSQL.

If deploying on GKE it is recommended to set `kubernetes_persistent_volume_claim_storage_class_name = "premium-rwo"` to use a SSD storage volume for the pgdata directory which gives faster IOP's and better database performance.

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

- [kubernetes_service.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)
- [kubernetes_stateful_set.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: Kubernetes namespace to deploy to

Type: `string`

### <a name="input_password"></a> [password](#input\_password)

Description: n/a

Type: `string`

### <a name="input_user"></a> [user](#input\_user)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_logstatement_logging"></a> [enable\_logstatement\_logging](#input\_enable\_logstatement\_logging)

Description: Enable Postgres logestament=all logging for debug purposes

Type: `bool`

Default: `false`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: n/a

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: n/a

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_persistent_volume_claim_storage_class_name"></a> [kubernetes\_persistent\_volume\_claim\_storage\_class\_name](#input\_kubernetes\_persistent\_volume\_claim\_storage\_class\_name)

Description: n/a

Type: `string`

Default: `"standard"`

### <a name="input_kubernetes_persistent_volume_claim_storage_class_size"></a> [kubernetes\_persistent\_volume\_claim\_storage\_class\_size](#input\_kubernetes\_persistent\_volume\_claim\_storage\_class\_size)

Description: n/a

Type: `string`

Default: `"10Gi"`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: Additional annotations to add to Kubernetes Postgres service definition

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

## Outputs

The following outputs are exported:

### <a name="output_host"></a> [host](#output\_host)

Description: n/a

### <a name="output_port"></a> [port](#output\_port)

Description: n/a
<!-- END_TF_DOCS -->