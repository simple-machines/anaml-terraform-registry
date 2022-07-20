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
| [kubernetes_deployment.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_cloudsql_image_repository"></a> [gcp\_cloudsql\_image\_repository](#input\_gcp\_cloudsql\_image\_repository) | Available - See https://github.com/GoogleCloudPlatform/cloudsql-proxy - gcr.io/cloudsql-docker/gce-proxy - us.gcr.io/cloudsql-docker/gce-proxy - eu.gcr.io/cloudsql-docker/gce-proxy - asia.gcr.io/cloudsql-docker/gce-proxy | `string` | `"gcr.io/cloudsql-docker/gce-proxy"` | no |
| <a name="input_gcp_cloudsql_instances"></a> [gcp\_cloudsql\_instances](#input\_gcp\_cloudsql\_instances) | n/a | `list(string)` | n/a | yes |
| <a name="input_gcp_cloudsql_proxy_version"></a> [gcp\_cloudsql\_proxy\_version](#input\_gcp\_cloudsql\_proxy\_version) | n/a | `string` | `"1.31.0"` | no |
| <a name="input_gcp_cloudsql_structured_logs"></a> [gcp\_cloudsql\_structured\_logs](#input\_gcp\_cloudsql\_structured\_logs) | n/a | `bool` | `true` | no |
| <a name="input_gcp_cloudsql_use_private_ip"></a> [gcp\_cloudsql\_use\_private\_ip](#input\_gcp\_cloudsql\_use\_private\_ip) | n/a | `bool` | `true` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Kubernetes labels to set if any. These values will be merged with the defaults | `map(string)` | `null` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"cloudsql-proxy"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account) | n/a | `string` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Kubernetes service annotations to set if any | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_enable"></a> [kubernetes\_service\_enable](#input\_kubernetes\_service\_enable) | n/a | `bool` | `false` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"ClusterIP"` | no |

## Outputs

No outputs.


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
| [kubernetes_deployment.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_cloudsql_image_repository"></a> [gcp\_cloudsql\_image\_repository](#input\_gcp\_cloudsql\_image\_repository) | Available - See https://github.com/GoogleCloudPlatform/cloudsql-proxy - gcr.io/cloudsql-docker/gce-proxy - us.gcr.io/cloudsql-docker/gce-proxy - eu.gcr.io/cloudsql-docker/gce-proxy - asia.gcr.io/cloudsql-docker/gce-proxy | `string` | `"gcr.io/cloudsql-docker/gce-proxy"` | no |
| <a name="input_gcp_cloudsql_instances"></a> [gcp\_cloudsql\_instances](#input\_gcp\_cloudsql\_instances) | n/a | `list(string)` | n/a | yes |
| <a name="input_gcp_cloudsql_proxy_version"></a> [gcp\_cloudsql\_proxy\_version](#input\_gcp\_cloudsql\_proxy\_version) | n/a | `string` | `"1.31.0"` | no |
| <a name="input_gcp_cloudsql_structured_logs"></a> [gcp\_cloudsql\_structured\_logs](#input\_gcp\_cloudsql\_structured\_logs) | n/a | `bool` | `true` | no |
| <a name="input_gcp_cloudsql_use_private_ip"></a> [gcp\_cloudsql\_use\_private\_ip](#input\_gcp\_cloudsql\_use\_private\_ip) | n/a | `bool` | `true` | no |
| <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels) | Kubernetes labels to set if any. These values will be merged with the defaults | `map(string)` | `null` | no |
| <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name) | n/a | `string` | `"cloudsql-proxy"` | no |
| <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_node_selector"></a> [kubernetes\_node\_selector](#input\_kubernetes\_node\_selector) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account) | n/a | `string` | `null` | no |
| <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations) | Kubernetes service annotations to set if any | `map(string)` | `null` | no |
| <a name="input_kubernetes_service_enable"></a> [kubernetes\_service\_enable](#input\_kubernetes\_service\_enable) | n/a | `bool` | `false` | no |
| <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type) | n/a | `string` | `"ClusterIP"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->