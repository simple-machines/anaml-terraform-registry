terraform {
  required_version = ">= 0.14"
  required_providers {
    anaml-operations = {
      source = "simple-machines/anaml-operations"
    }
  }
}


resource "anaml-operations_cluster" "spark_on_k8s_preview_cluster" {
  name               = "spark_on_k8s_preview_cluster"
  description        = "A Spark server cluster running on Kubernetes"
  is_preview_cluster = true

  spark_server {
    spark_server_url = var.anaml_spark_server_url
  }

  spark_config {
    enable_hive_support = false
    hive_metastore_url  = var.preview_cluster_hive_metastore_url
    additional_spark_properties = merge({
      # Preview Cluster Specific
      "spark.driver.bindAddress" : "0.0.0.0"
      "spark.driver.blockManager.port" : "7079"
      "spark.driver.host" : var.spark_driver_host
      "spark.driver.port" : var.spark_driver_port
      "spark.dynamicAllocation.executorIdleTimeout" : "1800s"

      # Optimize this based on number of users running previews concurrently
      "spark.dynamicAllocation.maxExecutors" : "4"
      "spark.executor.memory" : "6g"
      # Assuming not CPU bound, so we get two tasks assigned to just over 1 CPU
      "spark.executor.cores" : "2"
      "spark.kubernetes.executor.request.cores" : "1100m"
      "spark.kubernetes.executor.limit.cores" : "1100m"
    }, var.preview_cluster_spark_config_overrides)
  }
}

resource "anaml-operations_cluster" "spark_on_k8s_job_cluster" {
  name               = "spark_on_k8s_job_cluster"
  description        = "A Spark server cluster running on Kubernetes"
  is_preview_cluster = false

  spark_server {
    spark_server_url = var.anaml_spark_server_url
  }

  spark_config {
    enable_hive_support = false
    hive_metastore_url  = var.job_cluster_hive_metastore_url
    additional_spark_properties = merge({
      # Job cluster specific properties
      "spark.driver.extraClassPath" : "/opt/docker/lib/*"
      "spark.kubernetes.driver.podTemplateContainerName" : "spark-kubernetes-driver"
      "spark.kubernetes.driver.podTemplateFile" : "/config/spark-driver-template.yaml"

      # TODO - these probably should not be here as GCP specific and instead injected using job_cluster_spark_config_overrides
      "spark.kubernetes.driver.secrets.svc-anaml-credentials" : "/etc/secrets"
      "spark.kubernetes.driverEnv.GOOGLE_APPLICATION_CREDENTIALS" : "/etc/secrets/credentials.json"

      # Customize these based on jobs
      # These are optimized for machines with 8Gb per core.
      "spark.dynamicAllocation.maxExecutors" : "18",
      "spark.driver.memory" : "6g",
      "spark.executor.memory" : "8g",
      # Assuming not CPU bound, so we get two tasks assigned to just over 1 CPU
      "spark.driver.cores" : "2",
      "spark.executor.cores" : "2",
      "spark.kubernetes.driver.request.cores" : "2000m",
      "spark.kubernetes.driver.limit.cores" : "2000m",
      "spark.kubernetes.executor.request.cores" : "1100m",
      "spark.kubernetes.executor.limit.cores" : "1100m",
    }, var.job_cluster_spark_config_overrides)
  }
}

resource "anaml-operations_cluster" "event_store_cluster" {
  name               = "event_store_cluster"
  description        = "This cluster runs Event Store jobs"
  is_preview_cluster = false

  spark_server {
    spark_server_url = var.anaml_spark_server_url
  }

  spark_config {
    enable_hive_support = false
    hive_metastore_url  = var.event_store_cluster_hive_metastore_url
    additional_spark_properties = merge({
      # Job cluster specific properties
      "spark.driver.extraClassPath" : "/opt/docker/lib/*"
      "spark.kubernetes.driver.podTemplateContainerName" : "spark-kubernetes-driver"
      "spark.kubernetes.driver.podTemplateFile" : "/config/spark-driver-template.yaml"
      "spark.kubernetes.driver.secrets.svc-anaml-credentials" : "/etc/secrets"
      "spark.kubernetes.driverEnv.GOOGLE_APPLICATION_CREDENTIALS" : "/etc/secrets/credentials.json"

      # TODO - do these need to be external?
      "spark.kubernetes.driver.secretKeyRef.ANAML_APIKEY" : "event-store-spark:ANAML_APIKEY",
      "spark.kubernetes.driver.secretKeyRef.ANAML_SECRET" : "event-store-spark:ANAML_SECRET",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_SERVER" : "event-store-spark:DATABASE_SERVER",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_PORT" : "event-store-spark:DATABASE_PORT",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_USER" : "event-store-spark:DATABASE_USER",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_PASSWORD" : "event-store-spark:DATABASE_PASSWORD",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_NAME" : "event-store-spark:DATABASE_NAME",
      "spark.kubernetes.driver.secretKeyRef.DATABASE_SCHEMA" : "event-store-spark:DATABASE_SCHEMA",

      # Customize these based on jobs
      # These are optimized for machines with 8Gb per core.
      "spark.dynamicAllocation.maxExecutors" : "18",
      "spark.driver.memory" : "6g",
      "spark.executor.memory" : "8g",
      # Assuming not CPU bound, so we get two tasks assigned to just over 1 CPU
      "spark.driver.cores" : "2",
      "spark.executor.cores" : "2",
      "spark.kubernetes.driver.request.cores" : "2000m",
      "spark.kubernetes.driver.limit.cores" : "2000m",
      "spark.kubernetes.executor.request.cores" : "1100m",
      "spark.kubernetes.executor.limit.cores" : "1100m",
    }, var.event_store_cluster_spark_config_overrides)
  }
}
