terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}

locals {
  # Pinned to 14.4.0.
  version =  {
    number  = "14.4.0"
    sha     = "sha256:55a57492116045a79c4df4528a4778a31ea13ab31dbc4ee4d8f6c17f67422473"
  }

  deployment_labels = merge({
    "app.kubernetes.io/name"       = "postgres"
    "app.kubernetes.io/version"    = local.version.number
    "app.kubernetes.io/component"  = "database"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)
}


# Deploy a Postgres stateful set
# This should be used in non-production environments only
resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  spec {
    replicas               = 1
    revision_history_limit = 4
    service_name           = kubernetes_service.postgres.metadata[0].name
    selector {
      match_labels = local.deployment_labels
    }

    template {
      metadata {
        labels = local.deployment_labels
      }
      spec {
        # Set permissions on the volume so Postgres can write to it as user 1001 (Bitnami default postgres user)
        init_container {
          name = "init-chown-data"
          # Pinned to 1.31.1
          image = "busybox@sha256:dcdf379c574e1773d703f0c0d56d67594e7a91d6b84d11ff46799f60fb081c52"
          image_pull_policy = "IfNotPresent"
          command = ["chown", "-R", "1001:1001", "/bitnami/postgresql"]

          volume_mount {
            name       = "postgres-data"
            mount_path = "/bitnami/postgresql"
          }
        }


        container {
          name  = "postgres"
          # Bitnami is the re-packaged official Postgres contained with non root support. Bitnami is VMWare so we trust this image
          image = "bitnami/postgresql@${local.version.sha}"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRESQL_PASSWORD"
            value = var.password
          }
          env {
            name  = "POSTGRESQL_USERNAME"
            value = var.user
          }
          env {
            name  = "POSTGRESQL_DATABASE"
            value = "anaml" # Create the anaml database
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/bitnami/postgresql"
            sub_path   = "pgdata"
          }

          readiness_probe {
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 10
            exec {
              command = ["pg_isready", "--host", "127.0.0.1", "--timeout", "5", "--username", var.user, "--dbname", "anaml"]
            }
          }

          security_context {
            run_as_non_root = true
            run_as_user = 1001
          }

        }

        security_context {
          fs_group = 1001
        }

        termination_grace_period_seconds = 60
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 1
      }
    }

    volume_claim_template {
      metadata {
        name   = "postgres-data"
        labels = local.deployment_labels
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = var.kubernetes_persistent_volume_claim_storage_class_name
        resources {
          requests = {
            storage = var.kubernetes_persistent_volume_claim_storage_class_size
          }
        }
      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    annotations = var.kubernetes_service_annotations
    labels      = local.deployment_labels
    name        = "postgres"
    namespace   = var.kubernetes_namespace
  }

  spec {
    type     = var.kubernetes_service_type
    selector = local.deployment_labels
    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
