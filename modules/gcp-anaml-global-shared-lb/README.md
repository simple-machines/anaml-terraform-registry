# gcp-anaml-global-shared-lb

It's likely you do not want to deploy this!

## What is it?

This module is for multi-tenant environments allowing a GKE cluster serving multiple instances of Anaml to use a single GCP Global Loadbalancer for routing instead of a Loadbalancer per deployment if using standard Kubernetes Ingress.

This module relies upon Google Clouds and GKE built in Network Endpoint Group (NEG) functionality.

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
