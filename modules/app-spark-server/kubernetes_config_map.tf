resource "kubernetes_config_map" "anaml_spark_server_config" {
  metadata {
    name      = "anaml-spark-server-config"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = merge(

    # Generate custom Spark cluster executor templates
    {
      for spark_cluster in var.spark_cluster_configs : "${spark_cluster.cluster_name}-spark-executor-template.yaml" => spark_cluster.executor_pod_template
    },


    # Generate custom Spark cluster executor templates
    {
      for spark_cluster in var.spark_cluster_configs : "${spark_cluster.cluster_name}-spark-driver-template.yaml" => spark_cluster.driver_pod_template
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
        ),

        truststore              = var.ssl_kubernetes_secret_pkcs12_truststore != null ? "/tmp/certificates/java/truststore" : null,
        use_truststore_password = var.ssl_kubernetes_secret_pkcs12_truststore_password != null,

        keystore              = var.ssl_kubernetes_secret_pkcs12_keystore != null ? "/tmp/certificates/java/keystore" : null,
        use_keystore_password = var.ssl_kubernetes_secret_pkcs12_keystore_password != null,

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

resource "kubernetes_config_map" "anaml_spark_history_server_config" {
  metadata {
    name      = "anaml-spark-history-server-config"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  # The anaml-spark-docker default log4j conf suppresses more logs than we want for the history-server.
  # Instead we provide the history server it's own log config
  # TODO: we should bake a spark-history.log4j.properties config file in to /opt/spark/conf and use
  # SPARK_HISTORY_OPTS="-Dlog4j2.configurationFile=/opt/spark/conf/spark-history.log4j.properties"
  data = {
    "log4j.properties" = <<EOT
# Set everything to be logged to the console
log4j.rootCategory=INFO, console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yy/MM/dd HH:mm:ss} %p %c{1}: %m%n

# Set the default spark-shell log level to WARN. When running the spark-shell, the
# log level for this class is used to overwrite the root logger's log level, so that
# the user can have different defaults for the shell and regular Spark apps.
log4j.logger.org.apache.spark.repl.Main=WARN

# Settings to quiet third party logs that are too verbose
log4j.logger.org.sparkproject.jetty=WARN
log4j.logger.org.sparkproject.jetty.util.component.AbstractLifeCycle=ERROR
log4j.logger.org.apache.spark.repl.SparkIMain$exprTyper=INFO
log4j.logger.org.apache.spark.repl.SparkILoop$SparkILoopInterpreter=INFO
log4j.logger.org.apache.parquet=ERROR
log4j.logger.parquet=ERROR

# SPARK-9183: Settings to avoid annoying messages when looking up nonexistent UDFs in SparkSQL with Hive support
log4j.logger.org.apache.hadoop.hive.metastore.RetryingHMSHandler=FATAL
log4j.logger.org.apache.hadoop.hive.ql.exec.FunctionRegistry=ERROR

# For deploying Spark ThriftServer
# SPARK-34128：Suppress undesirable TTransportException warnings involved in THRIFT-4805
log4j.appender.console.filter.1=org.apache.log4j.varia.StringMatchFilter
log4j.appender.console.filter.1.StringToMatch=Thrift error occurred during processing of message
log4j.appender.console.filter.1.AcceptOnMatch=false
EOT
  }


}
