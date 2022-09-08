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
      "spark.eventLog.enabled"                                                  = "true"
      "spark.eventLog.dir"                                                      = var.spark_log_directory
      "spark.executor.extraClassPath"                                           = "/opt/docker/lib/*"
      "spark.hadoop.fs.AbstractFileSystem.gs.impl"                              = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS"
      "spark.hadoop.fs.gs.impl"                                                 = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem"
      "spark.hadoop.fs.gs.implicit.dir.infer.enable"                            = "true"
      "spark.hadoop.fs.gs.implicit.dir.repair.enable"                           = "false"
      "spark.hadoop.hive.execution.engine"                                      = "mr"
      "spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version"            = "2"
      "spark.kubernetes.allocation.batch.size"                                  = "2"
      "spark.kubernetes.container.image"                                        = local.image
      "spark.kubernetes.container.image.pullPolicy"                             = var.kubernetes_image_pull_policy == null ? (var.anaml_spark_server_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy
      "spark.kubernetes.executor.podTemplateFile"                               = "/config/spark-executor-template.yaml"
      "spark.kubernetes.executor.volumes.emptyDir.spark-local-dir-1.mount.path" = "/spark-work-dir-1"
      "spark.kubernetes.namespace"                                              = var.kubernetes_namespace
      "spark.kubernetes.node.selector.node_pool"                                = var.kubernetes_node_selector_spark_executor.node_pool
      "spark.local.dir"                                                         = "/spark-work-dir-1"
      "spark.scheduler.mode"                                                    = "FAIR"
      "spark.sql.autoBroadcastJoinThreshold"                                    = "96m"
      "spark.sql.adaptive.enabled"                                              = "true"
      "spark.sql.cbo.enabled"                                                   = "true"
      "spark.sql.cbo.joinReorder.enabled"                                       = "true"
    },
    var.kubernetes_service_account == null ? {} : { "spark.kubernetes.authenticate.driver.serviceAccountName" = var.kubernetes_service_account }
  )
}
