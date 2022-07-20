<!-- BEGIN_TF_DOCS -->
# gcp-gke-cluster/

Creates a private GKE cluster specifically for Anaml. The GKE cluster contains node pool for the application services and node pool specifically for Apache Spark workers.

This module mostly wraps the official Google Terraform GKE [private-cluster](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/21.1.0/submodules/private-cluster) module.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes)

- <a name="provider_random"></a> [random](#provider\_random)

## Modules

The following Modules are called:

### <a name="module_gke_auth"></a> [gke\_auth](#module\_gke\_auth)

Source: terraform-google-modules/kubernetes-engine/google//modules/auth

Version:

### <a name="module_gke_cluster"></a> [gke\_cluster](#module\_gke\_cluster)

Source: terraform-google-modules/kubernetes-engine/google//modules/private-cluster

Version: 21.2.0

## Resources

The following resources are used by this module:

- [kubernetes_pod_disruption_budget.kube_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_disruption_budget) (resource)
- [random_id.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id)

Description: The project ID to host the cluster in (required)

Type: `string`

### <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region)

Description: The region to host the cluster in (optional if zonal cluster / required if regional)

Type: `string`

### <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods)

Description: The _name_ of the secondary subnet ip range to use for pods

Type: `string`

### <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services)

Description: The _name_ of the secondary subnet range to use for services

Type: `string`

### <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version)

Description: The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region.

Type: `string`

### <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block)

Description: The IP range in CIDR notation used for the hosted master network

Type: `string`

### <a name="input_network"></a> [network](#input\_network)

Description: The VPC network to host the cluster in (required)

Type: `string`

### <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork)

Description: The subnetwork to host the cluster in (required)

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_app_pool_machine_type"></a> [anaml\_app\_pool\_machine\_type](#input\_anaml\_app\_pool\_machine\_type)

Description: n/a

Type: `string`

Default: `"e2-standard-2"`

### <a name="input_anaml_spark_pool_machine_type"></a> [anaml\_spark\_pool\_machine\_type](#input\_anaml\_spark\_pool\_machine\_type)

Description: n/a

Type: `string`

Default: `"e2-highmem-4"`

### <a name="input_gcp_zones"></a> [gcp\_zones](#input\_gcp\_zones)

Description: The zones to host the cluster in (optional if regional cluster / required if zonal)

Type: `list(string)`

Default: `[]`

### <a name="input_maintenance_end_time"></a> [maintenance\_end\_time](#input\_maintenance\_end\_time)

Description: (Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format

Type: `string`

Default: `null`

### <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time)

Description: (Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format

Type: `string`

Default: `null`

### <a name="input_max_anaml_app_node_pool_size"></a> [max\_anaml\_app\_node\_pool\_size](#input\_max\_anaml\_app\_node\_pool\_size)

Description: Maximum number of nodes in the animal application node pool

Type: `number`

Default: `3`

### <a name="input_max_anaml_spark_node_pool_size"></a> [max\_anaml\_spark\_node\_pool\_size](#input\_max\_anaml\_spark\_node\_pool\_size)

Description: Maximum number of nodes in the animal spark worker node pool

Type: `number`

Default: `8`

### <a name="input_min_anaml_app_node_pool_size"></a> [min\_anaml\_app\_node\_pool\_size](#input\_min\_anaml\_app\_node\_pool\_size)

Description: Minimum number of nodes in the animal application node pool

Type: `number`

Default: `2`

### <a name="input_min_anaml_spark_node_pool_size"></a> [min\_anaml\_spark\_node\_pool\_size](#input\_min\_anaml\_spark\_node\_pool\_size)

Description: Minimum number of nodes in the animal spark worker node pool

Type: `number`

Default: `0`

### <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)

Description: n/a

Type: `string`

Default: `"anaml-gke"`

### <a name="input_regional"></a> [regional](#input\_regional)

Description: Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)

Type: `bool`

Default: `true`

### <a name="input_service_account"></a> [service\_account](#input\_service\_account)

Description: The service account to run nodes as if not overridden in `node_pools`. The create\_service\_account variable default value (true) will cause a cluster-specific service account to be created.

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate)

Description: Cluster ca certificate (base64 encoded)

### <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id)

Description: Cluster ID

### <a name="output_endpoint"></a> [endpoint](#output\_endpoint)

Description: Cluster endpoint

### <a name="output_horizontal_pod_autoscaling_enabled"></a> [horizontal\_pod\_autoscaling\_enabled](#output\_horizontal\_pod\_autoscaling\_enabled)

Description: Whether horizontal pod autoscaling enabled

### <a name="output_http_load_balancing_enabled"></a> [http\_load\_balancing\_enabled](#output\_http\_load\_balancing\_enabled)

Description: Whether http load balancing enabled

### <a name="output_identity_namespace"></a> [identity\_namespace](#output\_identity\_namespace)

Description: Workload Identity pool

### <a name="output_instance_group_urls"></a> [instance\_group\_urls](#output\_instance\_group\_urls)

Description: List of GKE generated instance groups

### <a name="output_location"></a> [location](#output\_location)

Description: Cluster location (region if regional cluster, zone if zonal cluster)

### <a name="output_logging_service"></a> [logging\_service](#output\_logging\_service)

Description: Logging service used

### <a name="output_master_version"></a> [master\_version](#output\_master\_version)

Description: Current master kubernetes version

### <a name="output_min_master_version"></a> [min\_master\_version](#output\_min\_master\_version)

Description: Minimum master kubernetes version

### <a name="output_name"></a> [name](#output\_name)

Description: Cluster name

### <a name="output_network_policy_enabled"></a> [network\_policy\_enabled](#output\_network\_policy\_enabled)

Description: Whether network policy enabled

### <a name="output_region"></a> [region](#output\_region)

Description: Cluster region

### <a name="output_release_channel"></a> [release\_channel](#output\_release\_channel)

Description: The release channel of this cluster

### <a name="output_service_account"></a> [service\_account](#output\_service\_account)

Description: The service account to default running nodes as if not overridden in `node_pools`.

### <a name="output_type"></a> [type](#output\_type)

Description: Cluster type (regional / zonal)

### <a name="output_zones"></a> [zones](#output\_zones)

Description: List of zones in which the cluster resides
<!-- END_TF_DOCS -->