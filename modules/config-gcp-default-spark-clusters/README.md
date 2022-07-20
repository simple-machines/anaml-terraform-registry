<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_anaml-operations"></a> [anaml-operations](#provider\_anaml-operations) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [anaml-operations_cluster.event_store_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) | resource |
| [anaml-operations_cluster.spark_on_k8s_job_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) | resource |
| [anaml-operations_cluster.spark_on_k8s_preview_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_spark_server_url"></a> [anaml\_spark\_server\_url](#input\_anaml\_spark\_server\_url) | n/a | `string` | n/a | yes |
| <a name="input_event_store_cluster_hive_metastore_url"></a> [event\_store\_cluster\_hive\_metastore\_url](#input\_event\_store\_cluster\_hive\_metastore\_url) | n/a | `string` | `null` | no |
| <a name="input_event_store_cluster_spark_config_overrides"></a> [event\_store\_cluster\_spark\_config\_overrides](#input\_event\_store\_cluster\_spark\_config\_overrides) | n/a | `map(string)` | `{}` | no |
| <a name="input_job_cluster_hive_metastore_url"></a> [job\_cluster\_hive\_metastore\_url](#input\_job\_cluster\_hive\_metastore\_url) | n/a | `string` | `null` | no |
| <a name="input_job_cluster_spark_config_overrides"></a> [job\_cluster\_spark\_config\_overrides](#input\_job\_cluster\_spark\_config\_overrides) | n/a | `map(string)` | `{}` | no |
| <a name="input_preview_cluster_hive_metastore_url"></a> [preview\_cluster\_hive\_metastore\_url](#input\_preview\_cluster\_hive\_metastore\_url) | n/a | `string` | `null` | no |
| <a name="input_preview_cluster_spark_config_overrides"></a> [preview\_cluster\_spark\_config\_overrides](#input\_preview\_cluster\_spark\_config\_overrides) | n/a | `map(string)` | `{}` | no |
| <a name="input_spark_driver_host"></a> [spark\_driver\_host](#input\_spark\_driver\_host) | n/a | `string` | n/a | yes |
| <a name="input_spark_driver_port"></a> [spark\_driver\_port](#input\_spark\_driver\_port) | n/a | `string` | `7078` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_spark_job_cluster"></a> [spark\_job\_cluster](#output\_spark\_job\_cluster) | n/a |
| <a name="output_spark_job_event_store_cluster_name"></a> [spark\_job\_event\_store\_cluster\_name](#output\_spark\_job\_event\_store\_cluster\_name) | n/a |
| <a name="output_spark_preview_cluster_name"></a> [spark\_preview\_cluster\_name](#output\_spark\_preview\_cluster\_name) | n/a |
<!-- END_TF_DOCS -->