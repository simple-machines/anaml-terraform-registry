# gcp-anaml-global-shared-lb

It's likely you do not want to deploy this!

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
      override_anaml_ui_enable_new_functionality = true
      version                                    = "v1.5.4"
      ...
    },
    "test" = {
      ...
    }
  }
}


module "deployments" {
  source = "git@github.com:simple-machines/anaml-terraform-registry.git//anaml-all"

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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.53, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.53, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_service.backends](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_firewall.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.loadbalancer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.google_compute_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_health_check.http_18080](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.http_80](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.http_8080](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_managed_ssl_certificate.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [google_compute_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.urlmap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_service"></a> [default\_service](#input\_default\_service) | The backend service or backend bucket to use for the loadbalancer when none of the given routing rules match. | `string` | `null` | no |
| <a name="input_deployment_zone"></a> [deployment\_zone](#input\_deployment\_zone) | The anaml deployment GCP Zone, ie au-southeast10c | `string` | n/a | yes |
| <a name="input_deployments"></a> [deployments](#input\_deployments) | List of deployment names, i.e. ['dev', 'test']. These deployment names are used in combination with deployment\_zone, with deployments being accessible under a subdomain | `list(string)` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The root dns zone the deployments should be available under, i.e 'nonprod.anaml.app' | `string` | n/a | yes |
| <a name="input_gcp_project_name"></a> [gcp\_project\_name](#input\_gcp\_project\_name) | The GCP project name the loadbalancer should be deployed to | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix to use for resources, i.e. 'anaml-nonprod' or 'anaml-demo' | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The GCP Network (VPC) name to deploy the load balancer | `string` | n/a | yes |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | The GCP instance tags the loadbalancer firewall rule should target | `list(string)` | n/a | yes |

## Outputs

No outputs.
