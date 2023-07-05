<!-- BEGIN_TF_DOCS -->
# Anaml Demo Terraform module

This Terraform module creates demo Anaml resources for entities, tables, features, feature sets, and feature stores, intended to build upon generated demo data.

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

- [kubernetes_cron_job_v1.data_generation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job_v1) (resource)
- [kubernetes_job.data_generation_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job) (resource)
- [kubernetes_persistent_volume_claim.data_generation_volume](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_api_password"></a> [anaml\_api\_password](#input\_anaml\_api\_password)

Description: n/a

Type: `string`

### <a name="input_anaml_api_url"></a> [anaml\_api\_url](#input\_anaml\_api\_url)

Description: n/a

Type: `string`

### <a name="input_anaml_api_username"></a> [anaml\_api\_username](#input\_anaml\_api\_username)

Description: n/a

Type: `string`

### <a name="input_anaml_server_url"></a> [anaml\_server\_url](#input\_anaml\_server\_url)

Description: n/a

Type: `string`

### <a name="input_anaml_spark_server_url"></a> [anaml\_spark\_server\_url](#input\_anaml\_spark\_server\_url)

Description: n/a

Type: `string`

### <a name="input_input_path"></a> [input\_path](#input\_input\_path)

Description: n/a

Type: `string`

### <a name="input_job_cluster_id"></a> [job\_cluster\_id](#input\_job\_cluster\_id)

Description: n/a

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

### <a name="input_kubernetes_secret_anaml_api_password_key"></a> [kubernetes\_secret\_anaml\_api\_password\_key](#input\_kubernetes\_secret\_anaml\_api\_password\_key)

Description: n/a

Type: `string`

### <a name="input_kubernetes_secret_anaml_api_password_name"></a> [kubernetes\_secret\_anaml\_api\_password\_name](#input\_kubernetes\_secret\_anaml\_api\_password\_name)

Description: n/a

Type: `string`

### <a name="input_kubernetes_secret_pg_password_key"></a> [kubernetes\_secret\_pg\_password\_key](#input\_kubernetes\_secret\_pg\_password\_key)

Description: n/a

Type: `string`

### <a name="input_kubernetes_secret_pg_password_name"></a> [kubernetes\_secret\_pg\_password\_name](#input\_kubernetes\_secret\_pg\_password\_name)

Description: n/a

Type: `string`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: Kubernetes service account to run the job under. Ensure this service account has access to the `input_path` and `output_path` destinations

Type: `string`

### <a name="input_output_path"></a> [output\_path](#input\_output\_path)

Description: n/a

Type: `string`

### <a name="input_pg_host"></a> [pg\_host](#input\_pg\_host)

Description: n/a

Type: `string`

### <a name="input_pg_password"></a> [pg\_password](#input\_pg\_password)

Description: n/a

Type: `string`

### <a name="input_preview_cluster_id"></a> [preview\_cluster\_id](#input\_preview\_cluster\_id)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_demo_image_version"></a> [anaml\_demo\_image\_version](#input\_anaml\_demo\_image\_version)

Description: The version of oniomania (https://github.com/simple-machines/anaml-devops/tree/master/docker/anaml-demo-setup) container image to deploy

Type: `string`

Default: `"faaa2511bd9010678b9af31b189a81e8b183e824"`

### <a name="input_backdate_day_count"></a> [backdate\_day\_count](#input\_backdate\_day\_count)

Description: Number of days to generate backdated data for

Type: `number`

Default: `30`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-docs container

Type: `string`

Default: `"australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"`

### <a name="input_cron_schedule"></a> [cron\_schedule](#input\_cron\_schedule)

Description: The t 01:00+10:00 (AEST)

Type: `string`

Default: `"0 15 * * *"`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description: n/a

Type: `string`

Default: `"IfNotPresent"`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: (Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_max_cust"></a> [max\_cust](#input\_max\_cust)

Description: n/a

Type: `number`

Default: `200000`

### <a name="input_max_skus"></a> [max\_skus](#input\_max\_skus)

Description: n/a

Type: `number`

Default: `100000`

## Outputs

No outputs.
<!-- END_TF_DOCS -->