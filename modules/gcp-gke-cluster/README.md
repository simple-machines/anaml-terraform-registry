# gcp-anaml-gke-cluster/

Creates a private GKE cluster specifically for Anaml. The GKE cluster contains node pool for the application services and node pool specifically for Apache Spark workers.

This module mostly wraps the official Google Terraform GKE [private-cluster](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/21.1.0/submodules/private-cluster) module.
