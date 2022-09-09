resource "kubernetes_config_map" "anaml_spark_server_config" {
  metadata {
    name      = "anaml-spark-server-config"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = {
    "application.conf" = templatefile("${path.module}/_templates/application.conf", {
      checkpointLocation = var.checkpoint_location
      anamlServerUrl     = var.anaml_server_url
      spark_conf         = merge(local.spark_conf_base, var.spark_config_overrides)

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

    "log4j2.xml" = file("${path.module}/_templates/log4j2.xml")

    "spark-driver-template.yaml" = templatefile("${path.module}/_templates/spark-driver-template.yaml", {
      tolerations = setunion(local.default_driver_tolerations, var.additional_spark_driver_pod_tolerations)
    })

    "spark-executor-template.yaml" = templatefile("${path.module}/_templates/spark-executor-template.yaml", {
      tolerations = setunion(local.default_executor_tolerations, var.additional_spark_executor_pod_tolerations)
    })
  }
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
