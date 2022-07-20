# Postgres Kubernetes stateful set deployment

This module should be used for non production deployments and testing only.

We recommend production deployments use AWS RDS or Google Cloud SQL instead of self managing PostgreSQL.

If deploying on GKE it is recommended to set `kubernetes_persistent_volume_claim_storage_class_name = "premium-rwo"` to use a SSD storage volume for the pgdata directory which gives faster IOP's and better database performance.

<!-- BEGIN_TF_DOCS -->
# Postgres Kubernetes stateful set deployment

> :warning: This module should be used for non production deployments and testing only.

We recommend production deployments use AWS RDS or Google Cloud SQL instead of self managing PostgreSQL.

If deploying on GKE it is recommended to set `kubernetes_persistent_volume_claim_storage_class_name = "premium-rwo"` to use a SSD storage volume for the pgdata directory which gives faster IOP's and better database performance.

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
| [kubernetes_service.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_logstatement_logging"></a> [enable\_logstatement\_logging](#input\_enable\_logstatement\_logging) | Enable Postgres logestament=all logging for debug purposes | `bool` | `false` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace to deploy to | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_persistent_volume_claim_storage_class_name"></a> [kubernetes\_persistent\_volume\_claim\_storage\_class\_name](#input\_kubernetes\_persistent\_volume\_claim\_storage\_class\_name) | n/a | `string` | `"standard"` | no |
| <a name="input_kubernetes_persistent_volume_claim_storage_class_size"></a> [kubernetes\_persistent\_volume\_claim\_storage\_class\_size](#input\_kubernetes\_persistent\_volume\_claim\_storage\_class\_size) | n/a | `string` | `"10Gi"` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Additional annotations to add to Kubernetes Postgres service definition | `map(string)` | `{}` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"NodePort"` | no |
| <a name="input_password"></a> [password](#input\_password) | n/a | `string` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
<!-- END_TF_DOCS -->