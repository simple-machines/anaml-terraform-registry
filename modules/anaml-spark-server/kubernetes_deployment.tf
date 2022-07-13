resource "kubernetes_deployment" "anaml_spark_server_deployment" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.anaml_spark_server_labels
  }
  spec {
    selector {
      match_labels = local.anaml_spark_server_labels
    }
    template {
      metadata {
        name      = var.kubernetes_deployment_name
        namespace = var.kubernetes_namespace
        labels    = local.anaml_spark_server_labels
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
            name = volume.value.name

            dynamic "secret" {
              for_each = volume.value.secret != null ? [volume.value.secret] : []
              content {
                secret_name = secret.value.secret_name
              }
            }

            dynamic "config_map" {
              for_each = volume.value.config_map != null ? [volume.value.config_map] : []
              content {
                name = config_map.name
              }
            }
          }
        }

        node_selector = var.kubernetes_node_selector_app

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

          # Mount the admin api auth tokens
          env_from {
            secret_ref {
              name = var.anaml_admin_api_kubernetes_secret_name
            }
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
              name  = env.value.name
              value = env.value.value
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
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
              read_only  = volume_mount.value.read_only
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

        # User provided sidecars i.e Google Cloud SQL Auth Proxy or Logging sidecars
        dynamic "container" {
          for_each = var.kubernetes_pod_sidecars == null ? [] : var.kubernetes_pod_sidecars

          content {
            name              = container.value.name
            image             = container.value.image
            image_pull_policy = container.value.image_pull_policy
            command           = container.value.command == null ? [] : container.value.command

            dynamic "env" {
              for_each = container.value.env == null ? [] : container.value.env
              content {
                name  = env.name
                value = env.value
              }
            }

            dynamic "env_from" {
              for_each = container.value.env_from == null ? [] : container.value.env_from
              content {
                dynamic "config_map_ref" {
                  for_each = env_from.value.config_map_ref == null ? [] : [env_from.value.config_map_ref]
                  content {
                    name = config_map_ref.value.name
                  }
                }

                dynamic "secret_ref" {
                  for_each = env_from.value.secret_ref == null ? [] : [env_from.value.secret_ref]
                  content {
                    name = secret_ref.value.name
                  }
                }
              }
            }

            dynamic "volume_mount" {
              for_each = container.value.volume_mount == null ? [] : container.value.volume_mount
              content {
                name       = volume_mount.value.name
                mount_path = volume_mount.value.mount_path
                read_only  = volume_mount.value.read_only
              }
            }

            dynamic "security_context" {
              for_each = container.value.security_context == null ? [] : [container.value.security_context]
              content {
                run_as_non_root = security_context.value.run_as_non_root
                run_as_group    = security_context.value.run_as_group
                run_as_user     = security_context.value.run_as_user
              }
            }

            dynamic "port" {
              for_each = container.value.port == null ? [] : [container.value.port]
              content {
                container_port = port.value.container_port
              }
            }

          }
        }
      }
    }
  }
}


resource "kubernetes_deployment" "spark_history_server_deployment" {
  metadata {
    name      = "spark-history-server"
    namespace = var.kubernetes_namespace
    labels    = local.spark_history_server_labels
  }
  spec {
    selector {
      match_labels = local.spark_history_server_labels
    }
    template {
      metadata {
        name      = "spark-history-server"
        namespace = "spark-history-server"
        labels    = local.spark_history_server_labels
      }
      spec {
        service_account_name = local.service_account_name

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.anaml_spark_server_config.metadata.0.name
          }
        }

        # Allow users to inject additional secret / config volumes.
        dynamic "volume" {
          for_each = var.spark_history_server_additional_volumes
          content {
            name = volume.value.name

            dynamic "secret" {
              for_each = volume.value.secret != null ? [volume.value.secret] : []
              content {
                secret_name = secret.value.secret_name
              }
            }

            dynamic "config_map" {
              for_each = volume.value.config_map != null ? [volume.value.config_map] : []
              content {
                name = config_map.name
              }
            }
          }
        }

        node_selector = var.kubernetes_node_selector_app

        container {
          name              = "spark-history-server"
          image             = local.image
          command           = ["/opt/spark/bin/spark-class", "org.apache.spark.deploy.history.HistoryServer"]
          image_pull_policy = var.kubernetes_image_pull_policy

          port {
            container_port = 18080
          }

          env {
            name = "JAVA_OPTS"
            value = join(" ", [
              "-Xmx2g -Dweb.host=0.0.0.0",
              "-Dlog4j2.configurationFile=/config/log4j2.xml"
            ])
          }

          env {
            name = "SPARK_HISTORY_OPTS"
            value = join(" ", [
              "-Dspark.history.fs.logDirectory=${var.spark_log_directory}",
              "-Dspark.ui.proxyBase=/spark-history",
              "-Dspark.history.fs.cleaner.enabled=true"
            ])
          }

          dynamic "env" {
            for_each = var.spark_history_server_additional_env_values
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          # Mount the admin api auth tokens
          env_from {
            secret_ref {
              name = var.anaml_admin_api_kubernetes_secret_name
            }
          }

          dynamic "env_from" {
            for_each = var.spark_history_server_additional_env_from
            content {
              dynamic "secret_ref" {
                for_each = [env_from.value.secret_ref]
                content {
                  name = secret_ref.value.name
                }
              }
            }
          }

          # Spark History Server re-uses log4j2.xml config from anaml-spark-server, it looks to
          # ignore other files under /config
          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }

          # User injected volume mounts - decouples AWS/GCP implementations
          dynamic "volume_mount" {
            for_each = var.spark_history_server_additional_volume_mounts
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
              read_only  = volume_mount.value.read_only
            }
          }

        }
      }
    }
  }
}
