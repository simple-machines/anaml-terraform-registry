/**
 * # demo-streaming-data-generation
 */

terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-demo-data-generation-streaming"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_producer_demo_version), ":", "_"),
      var.anaml_producer_demo_version
    )
    "app.kubernetes.io/component"  = "demo-data"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  kafka_config = merge({
    "acks" : "all"
    "bootstrap.servers" : var.kafka_bootstrap_servers
    "key.serializer" : "org.apache.kafka.common.serialization.VoidSerializer"
    "schema.registry.url" : var.kafka_schema_registry_url
    "value.serializer" : "io.confluent.kafka.serializers.KafkaAvroSerializer"
  }, var.kafka_additional_config)
}


resource "kubernetes_deployment" "kafka_data_generator" {
  metadata {
    name      = "anaml-demo-data-generation-streaming"
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
      }
    }
    template {
      metadata {
        name      = "anaml-demo-data-generation-streaming"
        namespace = "anaml"
        labels    = local.deployment_labels
      }
      spec {
        service_account_name = var.kubernetes_service_account_name

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.producer_demo_config.metadata.0.name
          }
        }

        volume {
          name = "data-generation-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.data_generation_volume.metadata.0.name
          }
        }

        node_selector = var.kubernetes_node_selector

        container {
          name = "anaml-producer-demo"
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_producer_demo_version))
            ? "${var.container_registry}/anaml-producer-demo@${var.anaml_producer_demo_version}"
            : "${var.container_registry}/anaml-producer-demo:${var.anaml_producer_demo_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_producer_demo_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

          env {
            name  = "ANAML_GS_PROJECT_ID"
            value = var.google_project_id
          }

          env {
            name  = "ANAML_GS_BUCKET"
            value = var.google_bucket
          }

          env {
            name  = "GS_CUSTOMER_SOURCE_PATH"
            value = var.customer_source_path
          }

          env {
            name  = "DATA_DIR"
            value = "/app/data"
          }

          env {
            name  = "JAVA_OPTS"
            value = "-Dconfig.file=/config/application.properties"
          }

          command = ["/app/start.sh"]

          volume_mount {
            name       = "data-generation-volume"
            mount_path = "/app/data"
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
            read_only  = true
          }
        }

      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "data_generation_volume" {
  metadata {
    name      = "anaml-demo-data-generation-streaming"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }

  wait_until_bound = false
}


resource "kubernetes_config_map" "producer_demo_config" {
  metadata {
    name      = "anaml-demo-data-generation-streaming"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = {
    "application.properties" = join("\n", sort([for k, v in local.kafka_config : "${k}=${v}"]))
  }
}
