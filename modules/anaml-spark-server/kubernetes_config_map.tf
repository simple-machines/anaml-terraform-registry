resource "kubernetes_config_map" "anaml_spark_server_config" {
  metadata {
    name      = "anaml-spark-server-config"
    namespace = var.kubernetes_namespace
  }

  data = {
    "application.conf" = templatefile("${path.module}/_templates/application.conf", {
      checkpointLocation  = var.checkpoint_location
      anamlServerUrl      = var.anaml_server_url
      spark_conf          = merge(local.spark_conf_base, var.spark_config_overrides)
      anamlServerUsername = var.anaml_server_user
      anamlServerPassword = var.anaml_server_password
    })
    "log4j2.xml"                   = file("${path.module}/_templates/log4j2.xml")
    "spark-driver-template.yaml"   = file("${path.module}/_templates/spark-driver-template.yaml")
    "spark-executor-template.yaml" = file("${path.module}/_templates/spark-executor-template.yaml")
  }
}

resource "kubernetes_config_map" "spark_defaults_conf" {
  metadata {
    name      = "anaml-spark-server-spark-defaults-conf"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  data = {
    "fairscheduler.xml" = file("${path.module}/_templates/fairscheduler.xml")
  }
}
