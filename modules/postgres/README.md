# Postgres Kubernetes stateful set deployment

This module should be used for non production deployments and testing only.

We recommend production deployments use AWS RDS or Google Cloud SQL instead of self managing PostgreSQL.

If deploying on GKE it is recommended to set `kubernetes_persistent_volume_claim_storage_class_name = "premium-rwo"` to use a SSD storage volume for the pgdata directory which gives faster IOP's and better database performance.
