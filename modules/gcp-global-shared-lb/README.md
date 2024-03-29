<!-- BEGIN_TF_DOCS -->
# gcp-global-shared-lb

> :warning: It's likely you do not want to deploy this!

## What is it?

This module is for multi-tenant environments allowing a GKE cluster serving multiple instances of Anaml to use a single GCP Global Loadbalancer for routing instead of a Loadbalancer per deployment if using standard Kubernetes Ingress.

This module relies on Google Clouds and GKE built in Network Endpoint Group (NEG) functionality.

To use this module deployments need to be annotated with `cloud.google.com/neg` annotations. See the below example:

```
locals {
  dns_zone    = "nonprod.anaml.app"
  name_prefix = "anaml-nonprod"
  network     = "anaml-vpc"

  deployments = {
    "dev" = {
      override_anaml_docs_version                = "v1.5.4-5-g645ac24"
      override_anaml_server_version              = "v1.5.4-31-gb15f5a72"
      override_anaml_ui_api_url                  = "v1.5.4-13-gaff59c3b"
      version                                    = "v1.5.4"
      ...
    },
    "test" = {
      ...
    }
  }
}

module "deployments" {
  source = "git@github.com:simple-machines/anaml-terraform-registry.git/modules//app-all"

  for_each = local.deployments

  # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
  kubernetes_service_annotations_anaml_docs = merge(
    { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "80" : { name : "anaml-${each.key}-docs" } } }) },
    try(each.value.kubernetes_service_annotations_anaml_docs, {})
  )

  # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
  kubernetes_service_annotations_anaml_server = merge(
    { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "8080" : { name : "anaml-${each.key}-server" } } }) },
    try(each.value.kubernetes_service_annotations_anaml_server, {})
  )

  # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
  kubernetes_service_annotations_anaml_ui = merge(
    { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "80" : { name : "anaml-${each.key}-ui" } } }) },
    try(each.value.kubernetes_service_annotations_anaml_ui, {})
  )

  ...
}
```

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1)

- <a name="requirement_google"></a> [google](#requirement\_google) (>= 3.53, < 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_google"></a> [google](#provider\_google) (>= 3.53, < 5.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [google_compute_backend_service.backends](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) (resource)
- [google_compute_firewall.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) (resource)
- [google_compute_global_address.loadbalancer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) (resource)
- [google_compute_global_forwarding_rule.google_compute_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) (resource)
- [google_compute_health_check.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) (resource)
- [google_compute_managed_ssl_certificate.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) (resource)
- [google_compute_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) (resource)
- [google_compute_url_map.urlmap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_deployment_zone"></a> [deployment\_zone](#input\_deployment\_zone)

Description: The anaml deployment GCP Zone, ie au-southeast10c

Type: `string`

### <a name="input_deployments"></a> [deployments](#input\_deployments)

Description: List of deployment names, i.e. ['dev', 'test']. These deployment names are used in combination with deployment\_zone, with deployments being accessible under a subdomain

Type: `list(string)`

### <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone)

Description: The root dns zone the deployments should be available under, i.e 'nonprod.anaml.app'

Type: `string`

### <a name="input_gcp_project_name"></a> [gcp\_project\_name](#input\_gcp\_project\_name)

Description: The GCP project name the loadbalancer should be deployed to

Type: `string`

### <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)

Description: The name prefix to use for resources, i.e. 'anaml-nonprod' or 'anaml-demo'

Type: `string`

### <a name="input_network"></a> [network](#input\_network)

Description: The GCP Network (VPC) name to deploy the load balancer

Type: `string`

### <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags)

Description: The GCP instance tags the loadbalancer firewall rule should target

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_docs_security_policy"></a> [anaml\_docs\_security\_policy](#input\_anaml\_docs\_security\_policy)

Description: (Optional) The security policy associated with this backend service.

Type: `string`

Default: `null`

### <a name="input_anaml_server_security_policy"></a> [anaml\_server\_security\_policy](#input\_anaml\_server\_security\_policy)

Description: (Optional) The security policy associated with this backend service.

Type: `string`

Default: `null`

### <a name="input_anaml_ui_security_policy"></a> [anaml\_ui\_security\_policy](#input\_anaml\_ui\_security\_policy)

Description: (Optional) The security policy associated with this backend service.

Type: `string`

Default: `null`

### <a name="input_default_service"></a> [default\_service](#input\_default\_service)

Description: The backend service or backend bucket to use for the loadbalancer when none of the given routing rules match.

Type: `string`

Default: `null`

### <a name="input_enable_backend_logging"></a> [enable\_backend\_logging](#input\_enable\_backend\_logging)

Description: (Optional) This field denotes the logging options for the load balancer traffic served by this backend service. If logging is enabled, logs will be exported to Stackdriver

Type: `bool`

Default: `false`

### <a name="input_enable_health_check_logging"></a> [enable\_health\_check\_logging](#input\_enable\_health\_check\_logging)

Description: (Optional) Indicates whether or not to export logs. This is false by default, which means no health check logging will be done.

Type: `bool`

Default: `false`

### <a name="input_spark_history_server_security_policy"></a> [spark\_history\_server\_security\_policy](#input\_spark\_history\_server\_security\_policy)

Description: (Optional) The security policy associated with this backend service.

Type: `string`

Default: `null`

## Outputs

No outputs.
<!-- END_TF_DOCS -->