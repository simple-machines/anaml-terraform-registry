<!-- BEGIN_TF_DOCS -->
# demo-batch-data-generation (DEPRECATED)

## WARNING: DEPRECATED
This module is DEPRECATED. Use https://github.com/simple-machines/anaml-terraform-registry/tree/main/modules/demo instead

This module
  - Runs a one-off data initialization **job** creating seed data at the `output_path`
  - installs a Kubernetes cron job generating new data on the specfied schedule

The specified `service_account` will need access to the `input_path` and `output_path` locations.

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

- [kubernetes_cron_job.data_generation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job) (resource)
- [kubernetes_job.data_generation_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job) (resource)
- [kubernetes_persistent_volume_claim.data_generation_volume](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_input_path"></a> [input\_path](#input\_input\_path)

Description: TODO

Type: `string`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: Kubernetes service account to run the job under. Ensure this service account has access to the `input_path` and `output_path` destinations

Type: `string`

### <a name="input_oniomania_image_version"></a> [oniomania\_image\_version](#input\_oniomania\_image\_version)

Description: The version of oniomania (https://github.com/HuwCampbell/oniomania) container image to deploy

Type: `string`

### <a name="input_output_path"></a> [output\_path](#input\_output\_path)

Description: TODO

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_cluster"></a> [cluster](#input\_cluster)

Description: n/a

Type: `string`

Default: `"anaml-dataproc-cluster-small"`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-docs container

Type: `string`

Default: `"australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker"`

### <a name="input_cron_schedule"></a> [cron\_schedule](#input\_cron\_schedule)

Description: The time to schedule test data generation job. Defaults to 02:00+11:00 (AEDT) and 01:00+10:00 (AEST)

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

Description: TODO

Type: `number`

Default: `200000`

### <a name="input_max_skus"></a> [max\_skus](#input\_max\_skus)

Description: TODO

Type: `number`

Default: `100000`

### <a name="input_run_init_job"></a> [run\_init\_job](#input\_run\_init\_job)

Description: Run the init job if the input\_path is empty/first time running the data-generation. Defaults to true

Type: `bool`

Default: `true`

## Outputs

No outputs.
<!-- END_TF_DOCS -->