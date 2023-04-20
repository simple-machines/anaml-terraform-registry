locals {
  base_deployment_labels = merge({
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_spark_server_version), ":", "_"),
      var.anaml_spark_server_version
    )
    "app.kubernetes.io/component"  = "spark"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  anaml_spark_server_labels = merge(local.base_deployment_labels, {
    "app.kubernetes.io/name" = "anaml-spark-server"
  })

  spark_history_server_labels = merge(local.base_deployment_labels, {
    "app.kubernetes.io/name" = "spark-history-server"
  })

  image = (
    can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_spark_server_version))
    ? "${var.container_registry}/anaml-spark-server@${var.anaml_spark_server_version}"
    : "${var.container_registry}/anaml-spark-server:${var.anaml_spark_server_version}"
  )

  # Platform independent spark conf.
  # GCP/AWS specfic conf is injected in and merged using var.spark_config_overrides
  spark_conf_base = merge(
    {
      "spark.dynamicAllocation.enabled"                                         = "true"
      "spark.dynamicAllocation.schedulerBacklogTimeout"                         = "2s"
      "spark.dynamicAllocation.shuffleTracking.enabled"                         = "true"
      "spark.driver.extraClassPath"                                             = "/opt/docker/lib/*"
      "spark.executor.extraClassPath"                                           = "/opt/docker/lib/*"
      "spark.executor.extraJavaOptions"                                         = "-Djava.library.path=/opt/hadoop/lib/native:/usr/lib"
      "spark.hadoop.fs.AbstractFileSystem.gs.impl"                              = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS"
      "spark.hadoop.fs.gs.impl"                                                 = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem"
      "spark.hadoop.fs.gs.implicit.dir.infer.enable"                            = "true"
      "spark.hadoop.fs.gs.implicit.dir.repair.enable"                           = "false"
      "spark.hadoop.hive.execution.engine"                                      = "mr"
      "spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version"            = "2"
      "spark.kubernetes.allocation.batch.size"                                  = "2"
      "spark.kubernetes.container.image"                                        = local.image
      "spark.kubernetes.container.image.pullPolicy"                             = var.kubernetes_image_pull_policy == null ? (var.anaml_spark_server_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy
      "spark.kubernetes.driver.podTemplateFile"                                 = "/config/spark-driver-template.yaml"
      "spark.kubernetes.executor.podTemplateFile"                               = "/config/spark-executor-template.yaml"
      "spark.kubernetes.executor.volumes.emptyDir.spark-local-dir-1.mount.path" = "/spark-work-dir-1"
      "spark.kubernetes.namespace"                                              = var.kubernetes_namespace
      "spark.kubernetes.report.interval"                                        = "30s"
      "spark.local.dir"                                                         = "/spark-work-dir-1"
      "spark.scheduler.mode"                                                    = "FAIR"
      "spark.sql.adaptive.enabled"                                              = "true"
      "spark.sql.autoBroadcastJoinThreshold"                                    = "96m"
      "spark.sql.cbo.enabled"                                                   = "true"
      "spark.sql.cbo.joinReorder.enabled"                                       = "true"
      "spark.sql.adaptive.coalescePartitions.parallelismFirst"                  = "false"
      "spark.dynamicAllocation.executorAllocationRatio"                         = "0.3"
      "spark.dynamicAllocation.initialExecutors"                                = "2"

      # These settings are for nodes with 4Gb per core and at least 4 cores
      # For most production jobs, it is recommended to have 8Gb per core and override these
      # Based on https://cloud.google.com/dataproc-serverless/docs/concepts/properties
      "spark.driver.memory" = "13400m"
      "spark.executor.memory" = "13400m"
      "spark.driver.cores" = "4"
      "spark.executor.cores" = "4"
      "spark.kubernetes.driver.request.cores" = "3500m"
      "spark.kubernetes.driver.limit.cores" = "3500m"
      "spark.kubernetes.executor.request.cores" = "3500m"
      "spark.kubernetes.executor.limit.cores" = "3500m"

      # This will give a small spark job by default, and should usually be overriden on a Cluster or Schedule level
      "spark.dynamicAllocation.maxExecutors": "7"
    },

    var.kubernetes_node_selector_spark_driver == null ? {} : {
      "spark.kubernetes.driver.node.selector.node_pool" = var.kubernetes_node_selector_spark_driver.node_pool
    },
    var.kubernetes_node_selector_spark_executor == null ? {} : {
      "spark.kubernetes.executor.node.selector.node_pool" = var.kubernetes_node_selector_spark_executor.node_pool
    },

    var.spark_log_directory == null ? {} : {
      "spark.eventLog.dir"     = var.spark_log_directory
      "spark.eventLog.enabled" = "true"
    },

    var.kubernetes_service_account_spark_driver_executor == null ? {} : {
      "spark.kubernetes.authenticate.driver.serviceAccountName"   = var.kubernetes_service_account_spark_driver_executor
      "spark.kubernetes.authenticate.executor.serviceAccountName" = var.kubernetes_service_account_spark_driver_executor
    }
  )

  default_executor_template_tolerations = [
    {
      key      = "spark-only"
      operator = "Exists"
      effect   = "NoSchedule"
    }
  ]

  default_driver_template_tolerations = [
    {
      key      = "spark-only"
      operator = "Exists"
      effect   = "NoSchedule"
    }
  ]

  default_log4j_loggers = {
    # root logger is info
    "io.anaml" : "debug"

    # Quiet down spark stuff
    "com.google.cloud.spark.bigquery.repackaged" : "warn"
    "org.apache.hadoop" : "warn"
    "org.apache.parquet" : "warn"
    "org.apache.spark.deploy.yarn.Client" : "warn"
    "org.apache.spark.executor" : "warn"
    "org.apache.spark.scheduler.TaskSetManager" : "warn"
    "org.apache.spark.sql.execution" : "warn"
    "org.apache.spark.storage.BlockManagerInfo" : "warn"
    "org.apache.spark.storage.ShuffleBlockFetcherIterator" : "warn"
    "org.eclipse.jetty" : "warn"
    "org.http4s.blaze" : "warn"
    "org.spark_project.jetty" : "warn"
    "org.sparkproject.jetty" : "warn"
  }
}
