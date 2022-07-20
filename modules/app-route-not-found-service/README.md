# anaml-routing-not-found service

It's likely you do not want to deploy this!

## What is it?

anaml-routing-not-found service is primarily used in a multi host hosting environment where we want to serve a branded "404 Page Not Found" when a route does not match.

This is mainly used internally for deployments that use a shared Google Global Loadbalancer that requires a default service backend for route misses to server multiple Anaml deployments running off a single Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_deployment.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_route_not_found_service_version"></a> [anaml\_route\_not\_found\_service\_version](#input\_anaml\_route\_not\_found\_service\_version) | The version of anaml-route-not-found-service to deploy | `string` | `"v0.3"` | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The container registry to use to fetch the anaml-docs container | `string` | `"gcr.io/anaml-release-artifacts"` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Kubernetes labels to set if any. These values will be merged with the defaults | `map(string)` | `null` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"anaml-route-not-found-service"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace_name"></a> [kubernetes\_namespace\_name](#input\_kubernetes\_namespace\_name) | Kubernetes namespace to deploy to. This should be set if create\_anaml\_namespace is false | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Kubernetes service annotations to set if any | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"ClusterIP"` | no |

## Outputs

No outputs.


<!-- BEGIN_TF_DOCS -->
# app-routing-not-found service

> :warning: It's likely you do not want to deploy this!

## What is app-routing-not-found service?
anaml-routing-not-found service is primarily used in a multi host hosting environment where we want to serve a branded "404 Page Not Found" when a route does not match.

This is mainly used internally for deployments that use a shared Google Global Loadbalancer that requires a default service backend for route misses to server multiple Anaml deployments running off a single Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_deployment.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anaml_route_not_found_service_version"></a> [anaml\_route\_not\_found\_service\_version](#input\_anaml\_route\_not\_found\_service\_version) | The version of anaml-route-not-found-service to deploy | `string` | `"v0.3"` | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | The container registry to use to fetch the anaml-docs container | `string` | `"gcr.io/anaml-release-artifacts"` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Kubernetes labels to set if any. These values will be merged with the defaults | `map(string)` | `null` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"anaml-route-not-found-service"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace_name"></a> [kubernetes\_namespace\_name](#input\_kubernetes\_namespace\_name) | Kubernetes namespace to deploy to. This should be set if create\_anaml\_namespace is false | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Kubernetes service annotations to set if any | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"ClusterIP"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->