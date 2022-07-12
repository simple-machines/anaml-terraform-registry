resource "kubernetes_deployment" "anaml_spark_server_deployment" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    selector {
      match_labels = local.deployment_labels
    }
    template {
      metadata {
        name      = var.kubernetes_deployment_name
        namespace = var.kubernetes_namespace
        labels    = local.deployment_labels
      }
      spec {
        service_account_name = local.service_account_name

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.anaml_spark_server_config.metadata.0.name
          }
        }

        volume {
          name = "spark-conf"
          config_map {
            name = kubernetes_config_map.spark_defaults_conf.metadata.0.name
          }
        }

        # Allow users to inject additional secret / config volumes.
        dynamic "volume" {
          for_each = var.additional_volumes
          content {
            name = volume.name

            dynamic "secret" {
              for_each = volume.value.secret != null ? [volume.value.secret]:[]
              content {
                secret_name = secret.name
              }
            }

            dynamic "config_map" {
              for_each = volume.value.config_map != null ? [volume.value.config_map]:[]
              content {
                name = config_map.name
              }
            }
          }
        }

        node_selector = var.kubernetes_node_selector

        container {
          name              = "anaml-spark-server"
          image             = local.image
          command           = ["/opt/docker/bin/anaml-spark-server.sh"]
          image_pull_policy = var.kubernetes_image_pull_policy

          port {
            container_port = 8762
          }

          port {
            container_port = 7078
          }

          port {
            container_port = 7079
          }

          port {
            container_port = 4040
          }

          dynamic "env_from" {
            for_each = var.additional_env_from
            content {
              dynamic "secret_ref" {
                for_each = [env_from.value.secret_ref]
                content {
                  name = secret_ref.value.name
                }
              }
            }
          }

          env {
            name  = "ANAML_CONFIG_FILE"
            value = "/config/application.conf"
          }
          env {
            name  = "ANAML_LOGGING_CONFIG_FILE"
            value = "/config/log4j2.xml"
          }
          env {
            name  = "JAVA_OPTS"
            value = "-Dweb.host=0.0.0.0"
          }

          dynamic "env" {
            for_each = var.additional_env_values
            content {
              name  = env.name
              value = env.value
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }

          volume_mount {
            name       = "spark-conf"
            mount_path = "/opt/spark/conf"
            read_only  = true
          }

          # User injected volume mounts - decouples AWS/GCP implementations
          dynamic "volume_mount" {
            for_each = var.additional_volume_mounts
            content {
              name = volume_mount.name
              mount_path = volume_mount.mount_path
              read_only = volume_mount.read_only
            }
          }

          args = [
            "--databaseServerName=${var.postgres_host}",
            "--databasePortNumber=${var.postgres_port}",
            "--databaseName=${var.anaml_database_name}",
            "--databasePassword=${var.postgres_password}",
            "--databaseSchema=${var.anaml_database_schema_name}",
          ]
        }
      }
    }
  }
}
