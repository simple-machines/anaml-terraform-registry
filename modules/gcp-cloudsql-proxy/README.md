<!-- BEGIN_TF_DOCS -->
# Google Cloud SQL Auth Proxy Kubernetes deployment

This module deploys a standalone instance of [Google Cloud SQL Auth proxy](https://github.com/GoogleCloudPlatform/cloudsql-proxy)

We advice against deploying this as a standalone service, see Google's [Use the Cloud SQL Auth proxy in a production environment](https://cloud.google.com/sql/docs/postgres/sql-proxy#production-environment). It's likely you want to instead declare a sidecar for `anaml-server` if you use Google Cloud SQL.

This module is available primarily for debug purposes where you want to connect to the Google Cloud SQL database manually. In which case it's recommended you forward the port locally instead of enabling a Kubernetes Service:

```
NAMESPACE=anaml-dev
POD=$(kubectl -n $NAMESPACE get pods -l 'app.kubernetes.io/name=cloudsql-proxy' -o name)
kubectl -n $NAMESPACE port-forward $POD 5432:5432

psql -h 127.0.0.1 -p 5432 anaml anaml
```

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

- [kubernetes_deployment.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_service.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_gcp_cloudsql_instances"></a> [gcp\_cloudsql\_instances](#input\_gcp\_cloudsql\_instances)

Description: n/a

Type: `list(string)`

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_gcp_cloudsql_image_repository"></a> [gcp\_cloudsql\_image\_repository](#input\_gcp\_cloudsql\_image\_repository)

Description: Available - See https://github.com/GoogleCloudPlatform/cloudsql-proxy - gcr.io/cloudsql-docker/gce-proxy - us.gcr.io/cloudsql-docker/gce-proxy - eu.gcr.io/cloudsql-docker/gce-proxy - asia.gcr.io/cloudsql-docker/gce-proxy

Type: `string`

Default: `"gcr.io/cloudsql-docker/gce-proxy"`

### <a name="input_gcp_cloudsql_proxy_version"></a> [gcp\_cloudsql\_proxy\_version](#input\_gcp\_cloudsql\_proxy\_version)

Description: n/a

Type: `string`

Default: `"1.31.0"`

### <a name="input_gcp_cloudsql_structured_logs"></a> [gcp\_cloudsql\_structured\_logs](#input\_gcp\_cloudsql\_structured\_logs)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_gcp_cloudsql_use_private_ip"></a> [gcp\_cloudsql\_use\_private\_ip](#input\_gcp\_cloudsql\_use\_private\_ip)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Kubernetes labels to set if any. These values will be merged with the defaults

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: n/a

Type: `string`

Default: `"cloudsql-proxy"`

### <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_docs_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

Type: `string`

Default: `null`

### <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector)

Description: Optional) NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/node-selection).

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: Kubernetes service annotations to set if any

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_enable"></a> [kubernetes\_service\_enable](#input\_kubernetes\_service\_enable)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->