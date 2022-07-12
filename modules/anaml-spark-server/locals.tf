locals {
  deployment_labels = merge({
    "app.kubernetes.io/name"       = "anaml-spark-server"
    "app.kubernetes.io/version"    = var.anaml_spark_server_version
    "app.kubernetes.io/component"  = "spark"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  service_account_name = "svc-anaml"

  image = "${var.container_registry}/anaml-spark-server:${var.anaml_spark_server_version}"

  # Platform independent spark conf.
  # GCP/AWS specfic conf is injected in and merged using var.spark_config_overrides
  spark_conf_base = {
    "spark.dynamicAllocation.enabled"                                             = "true"
    "spark.dynamicAllocation.schedulerBacklogTimeout"                             = "2s"
    "spark.dynamicAllocation.shuffleTracking.enabled"                             = "true"
    "spark.eventLog.enabled"                                                      = "true"
    "spark.executor.extraClassPath"                                               = "/opt/docker/lib/*"
    "spark.executorEnv.ANAML_HISTORICAL_CHUNK_SIZE"                               = "10"
    "spark.hadoop.fs.AbstractFileSystem.gs.impl"                                  = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS"
    "spark.hadoop.fs.gs.impl"                                                     = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem"
    "spark.hadoop.fs.gs.implicit.dir.infer.enable"                                = "true"
    "spark.hadoop.fs.gs.implicit.dir.repair.enable"                               = "false"
    "spark.hadoop.hive.execution.engine"                                          = "mr"
    "spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version"                = "2"
    "spark.kubernetes.allocation.batch.size"                                      = "2"
    "spark.kubernetes.authenticate.driver.serviceAccountName"                     = local.service_account_name
    "spark.kubernetes.container.image"                                            = local.image
    "spark.kubernetes.container.image.pullPolicy"                                 = var.kubernetes_image_pull_policy
    "spark.kubernetes.executor.podTemplateFile"                                   = "/config/spark-executor-template.yaml"
    "spark.kubernetes.executor.secrets.${local.service_account_name}-credentials" = "/etc/secrets"
    "spark.kubernetes.executor.volumes.emptyDir.spark-local-dir-1.mount.path"     = "/spark-work-dir-1"
    "spark.kubernetes.memoryOverheadFactor"                                       = "0.1"
    "spark.kubernetes.namespace"                                                  = var.kubernetes_namespace
    "spark.kubernetes.node.selector.node_pool"                                    = var.kubernetes_node_selector_spark_executor.node_pool
    "spark.local.dir"                                                             = "/spark-work-dir-1"
    "spark.scheduler.mode"                                                        = "FAIR"
    "spark.sql.autoBroadcastJoinThreshold"                                        = "96m"
    "spark.sql.cbo.enabled"                                                       = "true"
    "spark.sql.cbo.joinReorder.enabled"                                           = "true"
  }
}
