terraform {
  required_version = ">= 1.1"
  required_providers {
    anaml = {
      source = "simple-machines/anaml"
    }
    anaml-operations = {
      source = "simple-machines/anaml-operations"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}
