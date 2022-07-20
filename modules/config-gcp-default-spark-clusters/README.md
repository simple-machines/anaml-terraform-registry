<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

## Providers

The following providers are used by this module:

- <a name="provider_anaml-operations"></a> [anaml-operations](#provider\_anaml-operations)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [anaml-operations_cluster.event_store_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) (resource)
- [anaml-operations_cluster.spark_on_k8s_job_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) (resource)
- [anaml-operations_cluster.spark_on_k8s_preview_cluster](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/cluster) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_spark_server_url"></a> [anaml\_spark\_server\_url](#input\_anaml\_spark\_server\_url)

Description: n/a

Type: `string`

### <a name="input_spark_driver_host"></a> [spark\_driver\_host](#input\_spark\_driver\_host)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_event_store_cluster_hive_metastore_url"></a> [event\_store\_cluster\_hive\_metastore\_url](#input\_event\_store\_cluster\_hive\_metastore\_url)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_event_store_cluster_spark_config_overrides"></a> [event\_store\_cluster\_spark\_config\_overrides](#input\_event\_store\_cluster\_spark\_config\_overrides)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_job_cluster_hive_metastore_url"></a> [job\_cluster\_hive\_metastore\_url](#input\_job\_cluster\_hive\_metastore\_url)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_job_cluster_spark_config_overrides"></a> [job\_cluster\_spark\_config\_overrides](#input\_job\_cluster\_spark\_config\_overrides)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_preview_cluster_hive_metastore_url"></a> [preview\_cluster\_hive\_metastore\_url](#input\_preview\_cluster\_hive\_metastore\_url)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_preview_cluster_spark_config_overrides"></a> [preview\_cluster\_spark\_config\_overrides](#input\_preview\_cluster\_spark\_config\_overrides)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_spark_driver_port"></a> [spark\_driver\_port](#input\_spark\_driver\_port)

Description: n/a

Type: `string`

Default: `7078`

## Outputs

The following outputs are exported:

### <a name="output_spark_job_cluster"></a> [spark\_job\_cluster](#output\_spark\_job\_cluster)

Description: n/a

### <a name="output_spark_job_event_store_cluster_name"></a> [spark\_job\_event\_store\_cluster\_name](#output\_spark\_job\_event\_store\_cluster\_name)

Description: n/a

### <a name="output_spark_preview_cluster_name"></a> [spark\_preview\_cluster\_name](#output\_spark\_preview\_cluster\_name)

Description: n/a
<!-- END_TF_DOCS -->