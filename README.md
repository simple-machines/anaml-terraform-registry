# ANAML Terraform repository

This repository contains modules related to ANAML deployment on Kuberernetes

To use a module use the below:

```
module "foo" {
  source = "git@github.com:simple-machines/anaml-terraform-registry.git//modules/[MODULE-NAME]"
  [INSERT MODULE PARAMETERS]
}
```

For most cases you will likely want to use [anaml-all](./anaml-all) which combines and deploys the below modules for you to a Kubernetes cluster:
  - [anaml-docs](./anaml-docs)
  - [anaml-kubernetes-ingress](./anaml-kubernetes-ingress) - (Optional) Anaml Kubernetes Ingress configuration
  - [anaml-server](./anaml-server)
  - [anaml-ui](./anaml-ui)
  - [postgres](./postgres) - (Optional) PostgreSQL stateful set primarily for non-production environments. We recommend managed AWS Azure or Google Cloud SQL for production environments.
  
## Container registries

Some modules require you to specify the container registry to use to fetch container Images.
We provide the below region specific container registries:

  - australia-southeast1-docker.pkg.dev/anaml-release-artifacts/docker


## Development

After cloning the git repo run the below command in the project root directory:

```
git config core.hooksPath .githooks
```

This will configure Git pre-commit hooks in `.githooks/pre-commit.d/` to be executed on commit. This handles document generation and formatting automatically. 
