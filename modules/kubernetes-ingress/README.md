<!-- BEGIN_TF_DOCS -->
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
| [kubernetes_ingress_v1.anaml_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_host"></a> [host](#input\_host) | n/a | `string` | `null` | no |
| <a name="input_kubernetes_ingress_annotations"></a> [kubernetes\_ingress\_annotations](#input\_kubernetes\_ingress\_annotations) | n/a | `map(string)` | `null` | no |
| <a name="input_kubernetes_ingress_name"></a> [kubernetes\_ingress\_name](#input\_kubernetes\_ingress\_name) | n/a | `string` | `"anaml"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->