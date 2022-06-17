# ANAML Terraform repository

This repository contains modules related to ANAML deployment on Kuberernetes

To use a module use the below:

```
module "foo" {
  source = "git@github.com:simple-machines/anaml-terraform-registry.git//[MODULE-NAME]"

  [INSERT MODULE PARAMETERS]

}
```

An example using the anaml-ui module:

```
module "anaml-ui" {
  source = "git@github.com:simple-machines/anaml-terraform-registry.git//anaml-ui"

  anaml_ui_version   = "v1.5.4"
  container_registry = "gcr.io/anaml-release-artifacts"

  kubernetes_cluster_ca_certificate = var.kubernetes_cluster_ca_certificate

  kubernetes_namespace = "default"
  kubernetes_host      = "https://127.0.0.1:6443"
  kubernetes_token     = var.kubernetes_token

  kubernetes_deployment_node_pool = "anaml-node-pool"

  hostname = "anaml.dev"
}

```
