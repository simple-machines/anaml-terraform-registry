<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_google"></a> [google](#requirement\_google) (>= 3.53.0, < 5.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.3)

## Providers

The following providers are used by this module:

- <a name="provider_google"></a> [google](#provider\_google) (>= 3.53.0, < 5.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.3)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google_sql_database.anaml](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) (resource)
- [google_sql_database_instance.anaml_postgres_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) (resource)
- [google_sql_user.users](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) (resource)
- [random_id.anaml_db_name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_ip_configuration_private_network_id"></a> [ip\_configuration\_private\_network\_id](#input\_ip\_configuration\_private\_network\_id)

Description: n/a

Type: `string`

### <a name="input_password"></a> [password](#input\_password)

Description: n/a

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: GCP project name.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: GCP region

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size)

Description: n/a

Type: `number`

Default: `20`

### <a name="input_insights_config_query_insights_enabled"></a> [insights\_config\_query\_insights\_enabled](#input\_insights\_config\_query\_insights\_enabled)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_insights_config_query_string_length"></a> [insights\_config\_query\_string\_length](#input\_insights\_config\_query\_string\_length)

Description: n/a

Type: `number`

Default: `1024`

### <a name="input_insights_config_record_application_tags"></a> [insights\_config\_record\_application\_tags](#input\_insights\_config\_record\_application\_tags)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_insights_config_record_client_address"></a> [insights\_config\_record\_client\_address](#input\_insights\_config\_record\_client\_address)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_ip_configuration_ipv4_enabled"></a> [ip\_configuration\_ipv4\_enabled](#input\_ip\_configuration\_ipv4\_enabled)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)

Description: n/a

Type: `string`

Default: `"anaml-"`

### <a name="input_postgresql_deploy_versions"></a> [postgresql\_deploy\_versions](#input\_postgresql\_deploy\_versions)

Description: Versions of PostgreSQL to deploy. Can facilitate with upgrades.

Type: `list(any)`

Default:

```json
[
  "13"
]
```

### <a name="input_tier"></a> [tier](#input\_tier)

Description: n/a

Type: `string`

Default: `"db-custom-2-8192"`

### <a name="input_user"></a> [user](#input\_user)

Description: n/a

Type: `string`

Default: `"anaml"`

## Outputs

The following outputs are exported:

### <a name="output_ca_cert"></a> [ca\_cert](#output\_ca\_cert)

Description: n/a

### <a name="output_ca_cert_common_name"></a> [ca\_cert\_common\_name](#output\_ca\_cert\_common\_name)

Description: n/a

### <a name="output_ca_cert_create_time"></a> [ca\_cert\_create\_time](#output\_ca\_cert\_create\_time)

Description: n/a

### <a name="output_ca_cert_expiration_time"></a> [ca\_cert\_expiration\_time](#output\_ca\_cert\_expiration\_time)

Description: n/a

### <a name="output_ca_cert_sha1_fingerprint"></a> [ca\_cert\_sha1\_fingerprint](#output\_ca\_cert\_sha1\_fingerprint)

Description: n/a

### <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name)

Description: n/a

### <a name="output_first_ip_address"></a> [first\_ip\_address](#output\_first\_ip\_address)

Description: n/a

### <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address)

Description: n/a

### <a name="output_ip_address_time_to_retire"></a> [ip\_address\_time\_to\_retire](#output\_ip\_address\_time\_to\_retire)

Description: n/a

### <a name="output_ip_address_type"></a> [ip\_address\_type](#output\_ip\_address\_type)

Description: n/a

### <a name="output_name"></a> [name](#output\_name)

Description: n/a

### <a name="output_pricate_ip_address"></a> [pricate\_ip\_address](#output\_pricate\_ip\_address)

Description: n/a

### <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address)

Description: n/a

### <a name="output_self_link"></a> [self\_link](#output\_self\_link)

Description: n/a

### <a name="output_service_account_email_address"></a> [service\_account\_email\_address](#output\_service\_account\_email\_address)

Description: n/a
<!-- END_TF_DOCS -->