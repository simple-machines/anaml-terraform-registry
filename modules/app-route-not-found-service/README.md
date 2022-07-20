<!-- BEGIN_TF_DOCS -->
# app-routing-not-found service Terraform module

:warning: It's likely you do not want to deploy this!

## What is app-routing-not-found service?
app-routing-not-found service is used in a multi host hosting environment when using a single GCP Global Load Balancer serving multiple sites where you must provided a default backend and want to serve a branded "404 Page Not Found" when a route does not match.

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

- [kubernetes_deployment.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.anaml_route_not_found_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_route_not_found_service_version"></a> [anaml\_route\_not\_found\_service\_version](#input\_anaml\_route\_not\_found\_service\_version)

Description: The version of anaml-route-not-found-service to deploy

Type: `string`

Default: `"v0.3"`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml\_route\_not\_found\_service\_version container

Type: `string`

Default: `"gcr.io/anaml-release-artifacts"`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: (Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)

Type: `string`

Default: `"anaml-route-not-found-service"`

### <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas)

Description: (Optional) The number of desired replicas. This attribute is a string to be able to distinguish between explicit zero and not specified. Defaults to 1. For more info see [Kubernetes reference](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)

Type: `string`

Default: `"1"`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_route_not_found_service_version` is set to`latest`, or IfNotPresent otherwise. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

Type: `string`

Default: `null`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: (Optional) Namespace defines the space within which name of the deployment must be unique.

Type: `string`

Default: `null`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: (Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: (Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->