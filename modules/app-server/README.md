<!-- BEGIN_TF_DOCS -->
# app-server Terraform module

This module deploys a Kubernetes Deployment and Service running the Anaml backend server application
## Terminating SSL inside the pod

By default Anaml UI uses plain HTTP and delegates SSL termination to Kubernetes Ingress.

If you wish to terminate SSL inside the pod, you should:

1) Create a JAVA pkcs12 truststore. Place it in a secret under the `javax.net.ssl.trustStore` key. If the trust store has a password you should create a secret for the password and place it under the javax.net.ssl.trustSTorePassword key.
2) Create a JAVA pkcs12 keystore. Place it in a secret under the `javax.net.ssl.keyStore` key. If the key store has a password you should create a secret for the password and place it under the javax.net.ssl.ketStorePassword key.
3) Set the `ssl_kubernetes_secret_pkcs12_truststore` variable with the name of the secret containing the trust store. Also set the `ssl_kubernetes_secret_pkcs12_truststore_password` variable with the name of the secret containing the truststore password if it has one
4) Set the `ssl_kubernetes_secret_pkcs12_keystore` variable with the name of the secret containing the key store. Also set the `ssl_kubernetes_secret_pkcs12_keystore_password` variable with the name of the secret containing the keystore password if it has one

See https://docs.oracle.com/cd/E19509-01/820-3503/6nf1il6er/index.html for details on creating Java key and tust stores

Example using Terraform for secrets:
```
resource "kubernetes_secret" "truststore" {
  metadata {
    name = "java-truststore"
    namespace = var.namespace
  }

  binary_data = {
    "javax.net.ssl.trustStore" = "${filebase64("./tmp_certs/cacerts")}"
  }
}

resource "kubernetes_secret" "truststore_password" {
  metadata {
    name = "java-truststore-password"
    namespace = var.namespace
  }

  data = {
    "javax.net.ssl.trustStorePassword" = "changeit"
  }
}

resource "kubernetes_secret" "keystore" {
  metadata {
    name = "java-keystore"
    namespace = var.namespace
  }

   binary_data = {
    "javax.net.ssl.keyStore" = "${filebase64("./tmp_certs/keystore.pfx")}"
  }
}

resource "kubernetes_secret" "keystore_password" {
  metadata {
    name = "java-keystore-password"
    namespace = var.namespace
  }

  data = {
    "javax.net.ssl.keyStorePassword" = "changeit"
  }
}
*
```
## SSL Notes
If you enable SSL on anaml-server you need to update your ingress to tell it to use HTTPS.
For the nginx ingress controller, this is done by adding the below annotation
```
"nginx.ingress.kubernetes.io/backend-protocol" : "HTTPS",
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

- [kubernetes_config_map.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) (resource)
- [kubernetes_deployment.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_secret.anaml_server_admin_api_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_secret.anaml_server_admin_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_secret.offline_license_response](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) (resource)
- [kubernetes_service.anaml_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_anaml_server_version"></a> [anaml\_server\_version](#input\_anaml\_server\_version)

Description: The version of anaml-server to deploy

Type: `string`

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: The container registry to use to fetch the anaml-server container

Type: `string`

### <a name="input_hostname"></a> [hostname](#input\_hostname)

Description: The external/public hostname to use for UI links. I.E. "anaml.example.com"

Type: `string`

### <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host)

Description: The host name of the Postgres database to connecto to

Type: `string`

### <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password)

Description: The password for the specified Postgres user. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGPASSWORD)`.

Type: `string`

### <a name="input_postgres_user"></a> [postgres\_user](#input\_postgres\_user)

Description: The user to connect to Postgres as. If the password is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(PGUSER)`.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_anaml_admin_email"></a> [anaml\_admin\_email](#input\_anaml\_admin\_email)

Description: If `enable_form_client` is `true`, the admin account email address for sign in

Type: `string`

Default: `null`

### <a name="input_anaml_admin_password"></a> [anaml\_admin\_password](#input\_anaml\_admin\_password)

Description: If `enable_form_client` is `true`, the initial admin account password for sign in

Type: `string`

Default: `null`

### <a name="input_anaml_admin_secret"></a> [anaml\_admin\_secret](#input\_anaml\_admin\_secret)

Description: The Anaml API service password. This is used internally by Anaml for service-to-service communication

Type: `string`

Default: `null`

### <a name="input_anaml_admin_token"></a> [anaml\_admin\_token](#input\_anaml\_admin\_token)

Description: The Anaml API service username. This is used internally by Anaml for service-to-service communication

Type: `string`

Default: `null`

### <a name="input_anaml_database_name"></a> [anaml\_database\_name](#input\_anaml\_database\_name)

Description: The name of the Postgres database to use for the Anaml Server.

Type: `string`

Default: `"anaml"`

### <a name="input_anaml_database_schema_name"></a> [anaml\_database\_schema\_name](#input\_anaml\_database\_schema\_name)

Description: The name of the Postgres schema to use for the Anaml server.

Type: `string`

Default: `"anaml"`

### <a name="input_enable_form_client"></a> [enable\_form\_client](#input\_enable\_form\_client)

Description: Enable Login form

Type: `bool`

Default: `false`

### <a name="input_governance_run_type_checks"></a> [governance\_run\_type\_checks](#input\_governance\_run\_type\_checks)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_kubernetes_container_env_from"></a> [kubernetes\_container\_env\_from](#input\_kubernetes\_container\_env\_from)

Description: Inject additional `env_from` values in to the deployment. This is useful for example if you want to mount the Postgres credentials from a secret\_ref to use in the `postgres_user` and `postgres_password` values

Type:

```hcl
list(object({
    secret_ref = object({
      name = string
    })
  }))
```

Default: `[]`

### <a name="input_kubernetes_deployment_labels"></a> [kubernetes\_deployment\_labels](#input\_kubernetes\_deployment\_labels)

Description: Additional labels to add to Kubernetes deployment

Type: `map(string)`

Default: `{}`

### <a name="input_kubernetes_deployment_name"></a> [kubernetes\_deployment\_name](#input\_kubernetes\_deployment\_name)

Description: (Optional) Name of the deployment, must be unique. Cannot be updated. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/identifiers#names)

Type: `string`

Default: `"anaml-server"`

### <a name="input_kubernetes_deployment_replicas"></a> [kubernetes\_deployment\_replicas](#input\_kubernetes\_deployment\_replicas)

Description: (Optional) The number of desired replicas. This attribute is a string to be able to distinguish between explicit zero and not specified. Defaults to 1. For more info see [Kubernetes reference](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)

Type: `string`

Default: `"1"`

### <a name="input_kubernetes_image_pull_policy"></a> [kubernetes\_image\_pull\_policy](#input\_kubernetes\_image\_pull\_policy)

Description:  (Optional) Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if `anaml_server_version` is set to`latest`, or IfNotPresent otherwise. For more info see [Kubernetes reference](http://kubernetes.io/docs/user-guide/images#updating-images)

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

### <a name="input_kubernetes_pod_sidecars"></a> [kubernetes\_pod\_sidecars](#input\_kubernetes\_pod\_sidecars)

Description: Optional sidecars to provision i.e. Google Cloud SQL Auth Proxy if deploying in GCP

Type:

```hcl
set(
    object({
      name              = string,
      image             = string,
      image_pull_policy = optional(string),

      command = optional(list(string))

      env = optional(list(object({
        name  = string,
        value = string,
      })))

      env_from = optional(list(object({
        config_map_ref = object({ name = string })
        secret_ref     = object({ name = string })
      })))

      volume_mount = optional(list(object({
        name       = string,
        mount_path = string,
        read_only  = bool
      })))

      security_context = optional(object({
        run_as_non_root = optional(bool)
        run_as_group    = optional(number)
        run_as_user     = optional(number)
      }))

      port = optional(object({
        container_port = number
      }))
    })
  )
```

Default: `[]`

### <a name="input_kubernetes_security_context"></a> [kubernetes\_security\_context](#input\_kubernetes\_security\_context)

Description: n/a

Type:

```hcl
object({
    run_as_user: number
    run_as_group: number
    fs_group: number
  })
```

Default: `null`

### <a name="input_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#input\_kubernetes\_service\_account\_name)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_kubernetes_service_annotations"></a> [kubernetes\_service\_annotations](#input\_kubernetes\_service\_annotations)

Description: (Optional) An unstructured key value map stored with the service that may be used to store arbitrary metadata.

Type: `map(string)`

Default: `null`

### <a name="input_kubernetes_service_type"></a> [kubernetes\_service\_type](#input\_kubernetes\_service\_type)

Description: (Optional) Determines how the service is exposed. Defaults to `ClusterIP`. Valid options are `ExternalName`, `ClusterIP`, `NodePort`, and `LoadBalancer`. `ExternalName` maps to the specified external\_name. For more info see [ Kubernetes reference](http://kubernetes.io/docs/user-guide/services#overview)

Type: `string`

Default: `"ClusterIP"`

### <a name="input_license_activation_data"></a> [license\_activation\_data](#input\_license\_activation\_data)

Description: License activation data for offline activation

Type: `string`

Default: `null`

### <a name="input_license_key"></a> [license\_key](#input\_license\_key)

Description: Your ANAML license key. If the license key is stored as a Kubernetes secret you can use the `kubernetes_container_env_from` option to make the secret available in the POD as a `secret_ref` and then reference it using standard Kubernetes syntax, i.e. by setting this value to `$(ANAML_LICENSE_KEY)`.

Type: `string`

Default: `null`

### <a name="input_license_offline_activation"></a> [license\_offline\_activation](#input\_license\_offline\_activation)

Description: If to use offline license activation

Type: `bool`

Default: `false`

### <a name="input_log4j_overrides"></a> [log4j\_overrides](#input\_log4j\_overrides)

Description: Override log4j default log levels. Format is class.name={debug|error|info|trace|warn}

Type: `map(string)`

Default: `{}`

### <a name="input_oidc_additional_scopes"></a> [oidc\_additional\_scopes](#input\_oidc\_additional\_scopes)

Description: OpenID Connect scopes to request from the provider. Optional when using OIDC authentication method.

Type: `set(string)`

Default: `[]`

### <a name="input_oidc_client_id"></a> [oidc\_client\_id](#input\_oidc\_client\_id)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_oidc_client_secret"></a> [oidc\_client\_secret](#input\_oidc\_client\_secret)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_oidc_discovery_uri"></a> [oidc\_discovery\_uri](#input\_oidc\_discovery\_uri)

Description: OpenID Connect discovery URI for OIDC authentcation. Required when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_oidc_enable"></a> [oidc\_enable](#input\_oidc\_enable)

Description: Enable OpenID Connect login

Type: `bool`

Default: `false`

### <a name="input_oidc_permitted_users_group_id"></a> [oidc\_permitted\_users\_group\_id](#input\_oidc\_permitted\_users\_group\_id)

Description: OpenID Connect user group to allow access to Anaml. Optional when using OIDC authentication method.

Type: `string`

Default: `null`

### <a name="input_override_java_opts"></a> [override\_java\_opts](#input\_override\_java\_opts)

Description: A list of JAVA\_OPT options to pass to anaml-server, i.e. `-XX:ActiveProcessorCount=8`

Type: `list(string)`

Default: `[]`

### <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port)

Description: The Postgres database port to connect to, defaults to 5432

Type: `number`

Default: `"5432"`

### <a name="input_proxy_base"></a> [proxy\_base](#input\_proxy\_base)

Description: (Optional) Controls the basepath used for redirects. Defaults to '/'

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore)

Description: (Optional) The name of the Kubernetes secret containing a Java pkcs12 keystore if you which to enable client SSL support and or enable HTTPS for anaml-server

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_key)

Description: (Optional) The Java pkcs12 keystore key inside the kubernetes\_secret\_pkcs12\_keystore value

Type: `string`

Default: `"javax.net.ssl.keyStore"`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_password"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_password](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_password)

Description: (Optional) The Kubernetes secret name containing the ssl\_kubernetes\_secret\_pkcs12\_keystore password if the keystore is password protected

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_keystore_password_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_keystore\_password\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_keystore\_password\_key)

Description: (Optional) The key used inside ssl\_kubernetes\_secret\_pkcs12\_keystore\_password for the trust store password if set

Type: `string`

Default: `"javax.net.ssl.keyStorePassword"`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore)

Description: (Optional) The name of the Kubernetes secret containing a Java pkcs12 truststore if you which to enable client SSL support and or enable HTTPS for anaml-server

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_key)

Description: (Optional) The Java pkcs12 truststore key inside the kubernetes\_secret\_pkcs12\_truststore value

Type: `string`

Default: `"javax.net.ssl.trustStore"`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_password"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_password](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_password)

Description: (Optional) The Kubernetes secret name containing the ssl\_kubernetes\_secret\_pkcs12\_truststore password if the truststore is password protected

Type: `string`

Default: `null`

### <a name="input_ssl_kubernetes_secret_pkcs12_truststore_password_key"></a> [ssl\_kubernetes\_secret\_pkcs12\_truststore\_password\_key](#input\_ssl\_kubernetes\_secret\_pkcs12\_truststore\_password\_key)

Description: (Optional) The key used inside ssl\_kubernetes\_secret\_pkcs12\_truststore\_password for the trust store password if set

Type: `string`

Default: `"javax.net.ssl.trustStorePassword"`

## Outputs

The following outputs are exported:

### <a name="output_anaml_admin_api_kubernetes_secret_name"></a> [anaml\_admin\_api\_kubernetes\_secret\_name](#output\_anaml\_admin\_api\_kubernetes\_secret\_name)

Description: n/a

### <a name="output_internal_url"></a> [internal\_url](#output\_internal\_url)

Description: n/a

### <a name="output_is_https"></a> [is\_https](#output\_is\_https)

Description: n/a

### <a name="output_kubernetes_service_name"></a> [kubernetes\_service\_name](#output\_kubernetes\_service\_name)

Description: n/a

### <a name="output_kubernetes_service_port_name"></a> [kubernetes\_service\_port\_name](#output\_kubernetes\_service\_port\_name)

Description: n/a

### <a name="output_kubernetes_service_port_number"></a> [kubernetes\_service\_port\_number](#output\_kubernetes\_service\_port\_number)

Description: n/a
<!-- END_TF_DOCS -->