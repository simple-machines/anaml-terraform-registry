# gcp-anaml-gke-cluster/

Creates a private GKE cluster specifically for Anaml. The GKE cluster contains node pool for the application services and node pool specifically for Apache Spark workers.

This module mostly wraps the official Google Terraform GKE [private-cluster](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/21.1.0/submodules/private-cluster) module.

<!-- BEGIN_TF_DOCS -->
# gcp-gke-cluster/

Creates a private GKE cluster specifically for Anaml. The GKE cluster contains node pool for the application services and node pool specifically for Apache Spark workers.

This module mostly wraps the official Google Terraform GKE [private-cluster](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/21.1.0/submodules/private-cluster) module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke_auth"></a> [gke\_auth](#module\_gke\_auth) | terraform-google-modules/kubernetes-engine/google//modules/auth | n/a |
| <a name="module_gke_cluster"></a> [gke\_cluster](#module\_gke\_cluster) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 21.2.0 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_pod_disruption_budget.kube_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod_disruption_budget) | resource |
| [random_id.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_app_pool_machine_type"></a> [anaml\_app\_pool\_machine\_type](#input\_anaml\_app\_pool\_machine\_type) | n/a | `string` | `"e2-standard-2"` | no |
| <a name="input_anaml_spark_pool_machine_type"></a> [anaml\_spark\_pool\_machine\_type](#input\_anaml\_spark\_pool\_machine\_type) | n/a | `string` | `"e2-highmem-4"` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The project ID to host the cluster in (required) | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The region to host the cluster in (optional if zonal cluster / required if regional) | `string` | n/a | yes |
| <a name="input_gcp_zones"></a> [gcp\_zones](#input\_gcp\_zones) | The zones to host the cluster in (optional if regional cluster / required if zonal) | `list(string)` | `[]` | no |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | The _name_ of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | The _name_ of the secondary subnet range to use for services | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | n/a | yes |
| <a name="input_maintenance_end_time"></a> [maintenance\_end\_time](#input\_maintenance\_end\_time) | (Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `null` | no |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | (Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `null` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation used for the hosted master network | `string` | n/a | yes |
| <a name="input_max_anaml_app_node_pool_size"></a> [max\_anaml\_app\_node\_pool\_size](#input\_max\_anaml\_app\_node\_pool\_size) | Maximum number of nodes in the animal application node pool | `number` | `3` | no |
| <a name="input_max_anaml_spark_node_pool_size"></a> [max\_anaml\_spark\_node\_pool\_size](#input\_max\_anaml\_spark\_node\_pool\_size) | Maximum number of nodes in the animal spark worker node pool | `number` | `8` | no |
| <a name="input_min_anaml_app_node_pool_size"></a> [min\_anaml\_app\_node\_pool\_size](#input\_min\_anaml\_app\_node\_pool\_size) | Minimum number of nodes in the animal application node pool | `number` | `2` | no |
| <a name="input_min_anaml_spark_node_pool_size"></a> [min\_anaml\_spark\_node\_pool\_size](#input\_min\_anaml\_spark\_node\_pool\_size) | Minimum number of nodes in the animal spark worker node pool | `number` | `0` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `"anaml-gke"` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the cluster in (required) | `string` | n/a | yes |
| <a name="input_regional"></a> [regional](#input\_regional) | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account to run nodes as if not overridden in `node_pools`. The create\_service\_account variable default value (true) will cause a cluster-specific service account to be created. | `string` | `""` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork to host the cluster in (required) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster ID |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_horizontal_pod_autoscaling_enabled"></a> [horizontal\_pod\_autoscaling\_enabled](#output\_horizontal\_pod\_autoscaling\_enabled) | Whether horizontal pod autoscaling enabled |
| <a name="output_http_load_balancing_enabled"></a> [http\_load\_balancing\_enabled](#output\_http\_load\_balancing\_enabled) | Whether http load balancing enabled |
| <a name="output_identity_namespace"></a> [identity\_namespace](#output\_identity\_namespace) | Workload Identity pool |
| <a name="output_instance_group_urls"></a> [instance\_group\_urls](#output\_instance\_group\_urls) | List of GKE generated instance groups |
| <a name="output_location"></a> [location](#output\_location) | Cluster location (region if regional cluster, zone if zonal cluster) |
| <a name="output_logging_service"></a> [logging\_service](#output\_logging\_service) | Logging service used |
| <a name="output_master_version"></a> [master\_version](#output\_master\_version) | Current master kubernetes version |
| <a name="output_min_master_version"></a> [min\_master\_version](#output\_min\_master\_version) | Minimum master kubernetes version |
| <a name="output_name"></a> [name](#output\_name) | Cluster name |
| <a name="output_network_policy_enabled"></a> [network\_policy\_enabled](#output\_network\_policy\_enabled) | Whether network policy enabled |
| <a name="output_region"></a> [region](#output\_region) | Cluster region |
| <a name="output_release_channel"></a> [release\_channel](#output\_release\_channel) | The release channel of this cluster |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The service account to default running nodes as if not overridden in `node_pools`. |
| <a name="output_type"></a> [type](#output\_type) | Cluster type (regional / zonal) |
| <a name="output_zones"></a> [zones](#output\_zones) | List of zones in which the cluster resides |
<!-- END_TF_DOCS -->