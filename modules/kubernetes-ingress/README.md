<!-- BEGIN_TF_DOCS -->
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

- [kubernetes_ingress_v1.anaml_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) (resource)
- [kubernetes_ingress_v1.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/ingress_v1) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_host"></a> [host](#input\_host)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_ingress_additional_paths"></a> [kubernetes\_ingress\_additional\_paths](#input\_kubernetes\_ingress\_additional\_paths)

Description: n/a

Type:

```hcl
list(
    object({
      path = string,
      backend = object({
        service = object({
          name = string
          port = object({
            number = number
          })
        })
      })
    })
  )
```

Default: `[]`

### <a name="input_kubernetes_ingress_annotations"></a> [kubernetes\_ingress\_annotations](#input\_kubernetes\_ingress\_annotations)

Description: n/a

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_ingress_name"></a> [kubernetes\_ingress\_name](#input\_kubernetes\_ingress\_name)

Description: n/a

Type: `string`

Default: `"anaml"`

### <a name="input_kubernetes_ingress_tls_hosts"></a> [kubernetes\_ingress\_tls\_hosts](#input\_kubernetes\_ingress\_tls\_hosts)

Description: n/a

Type: `set(string)`

Default: `null`

### <a name="input_kubernetes_ingress_tls_secret_name"></a> [kubernetes\_ingress\_tls\_secret\_name](#input\_kubernetes\_ingress\_tls\_secret\_name)

Description: n/a

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_dns_hostname"></a> [dns\_hostname](#output\_dns\_hostname)

Description: n/a
<!-- END_TF_DOCS -->