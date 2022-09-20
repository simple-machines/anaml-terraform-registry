resource "kubernetes_config_map" "anaml_spark_server_config" {
  metadata {
    name      = "anaml-spark-server-config"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = merge(
    # Generate dynamic Spark executor pod templates
    {
      for k, v in var.additional_spark_executor_pod_templates : "${k}-spark-executor-template.yaml" =>
      templatefile("${path.module}/_templates/spark-executor-template.yaml", {
        tolerations = v.tolerations
      })
    },

    # Generate dynamic Spark driver pod templates
    {
      for k, v in var.additional_spark_driver_pod_templates : "${k}-spark-driver-template.yaml" =>
      templatefile("${path.module}/_templates/spark-driver-template.yaml", {
        tolerations = v.tolerations
      })
    },


    {
      "application.conf" = templatefile("${path.module}/_templates/application.conf", {
        checkpointLocation = var.checkpoint_location
        anamlServerUrl     = var.anaml_server_url

        spark_conf = merge(
          # Allow overriding the "spark-local-dir-1" named volume
          # If the spark_config_overrides has a volume named "spark-local-dir-1" we drop the "spark-local-dir-1" setting in the base config
          anytrue(
            [for k in keys(var.spark_config_overrides) : can(regex("spark\\.kubernetes\\.executor\\.volumes\\.(hostPath|emptyDir|nfs|persistentVolumeClaim)\\.spark-local-dir-1", k))]
            ) ? (
            { for k, v in local.spark_conf_base : k => v if !can(regex("spark\\.kubernetes\\.executor\\.volumes\\.(hostPath|emptyDir|nfs|persistentVolumeClaim)\\.spark-local-dir-1", k)) }
            ) : (
            local.spark_conf_base
          ),

          var.spark_config_overrides
        )

        anamlServerUsername = try(
          // Allow Kubernetes style values and convert to Typesafe config format
          format("$${?%s}", one(regex("^\\$\\((\\w+)\\)$", var.anaml_server_user))),

          // Allow standard Typesafe config values and pass through as is
          format("%s", regex("^\\$\\{\\??\\w+\\}$", var.anaml_server_user)),

          // Allow string values
          format("\"%s\"", var.anaml_server_user),

          // If all else fails or is null
          var.anaml_server_user
        )

        anamlServerPassword = try(
          // Allow Kubernetes style values and convert to Typesafe config format
          format("$${?%s}", one(regex("^\\$\\((\\w+)\\)$", var.anaml_server_password))),

          // Allow standard Typesafe config values and pass through as is
          format("%s", regex("^\\$\\{\\??\\w+\\}$", var.anaml_server_password)),

          // Allow string values
          format("\"%s\"", var.anaml_server_password),

          // If all else fails or is null
          var.anaml_server_password
        )
      })

      "log4j2.xml" = templatefile("${path.module}/_templates/log4j2.xml", {
        loggers = merge(local.default_log4j_loggers, var.log4j_overrides)
      })

      "spark-driver-template.yaml" = templatefile("${path.module}/_templates/spark-driver-template.yaml", {
        tolerations = local.default_driver_template_tolerations
      })

      "spark-executor-template.yaml" = templatefile("${path.module}/_templates/spark-executor-template.yaml", {
        tolerations = local.default_executor_template_tolerations
      })
    }
  )
}

resource "kubernetes_config_map" "spark_defaults_conf" {
  metadata {
    name      = "anaml-spark-server-spark-defaults-conf"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = {
    "fairscheduler.xml" = file("${path.module}/_templates/fairscheduler.xml")
  }
}
