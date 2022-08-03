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
    "app.kubernetes.io/name"       = "anaml-demo-batch-data-generation"
    "app.kubernetes.io/version"    = var.anaml_producer_demo_version
    "app.kubernetes.io/component"  = "demo-data"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  kafka_config = merge({
    "bootstrap.servers": var.kafka_bootstrap_servers
    "key.serializer":  "org.apache.kafka.common.serialization.VoidSerializer"
    "value.serializer": "io.confluent.kafka.serializers.KafkaAvroSerializer"
    "schema.registry.url": var.kafka_schema_registry_url
  }, var.kafka_additional_config)

}


# resource "kubernetes_deployment" "kafka_data_generator" {
#   metadata {
#     name      = "anaml-producer-demo"
#     namespace = var.kubernetes_namespace
#     labels = local.deployment_labels
#   }
#   spec {
#     selector {
#       match_labels = {
#         "app.kubernetes.io/name" = local.deployment_labels["app.kubernetes.io/name"]
#       }
#     }
#     template {
#       metadata {
#         name      = "anaml-producer-demo"
#         namespace = "anaml"
#         labels = local.deployment_labels
#       }
#       spec {
#         service_account_name = "svc-data-generator"

#         # volume {
#         #   name = "config"
#         #   config_map {
#         #     name = kubernetes_config_map.producer_demo_config.metadata.0.name
#         #   }
#         # }

#         volume {
#           name = "data-generation-volume"
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim.data_generation_volume.metadata.0.name
#           }
#         }

#         node_selector = var.kubernetes_node_selector

#         container {
#           name              = "anaml-producer-demo"
#           image             = "${var.container_registry}/anaml-producer-demo:${anaml_producer_demo_version}"
#           image_pull_policy = var.kubernetes_image_pull_policy == null ? (var.anaml_server_version == "latest" ? "Always" : "IfNotPresent") : var.kubernetes_image_pull_policy

#           env {
#             name  = "ANAML_GS_PROJECT_ID"
#             value = var.google_project_id
#           }

#           env {
#             name  = "ANAML_GS_BUCKET"
#             value = var.google_bucket
#           }

#           env {
#             name  = "GS_CUSTOMER_SOURCE_PATH"
#             value = var.customer_source_path
#           }

#           env {
#             name  = "DATA_DIR"
#             value = "/app/data"
#           }

#           env {
#             name  = "JAVA_OPTS"
#             value = "-Dconfig.file=/config/application.properties"
#           }

#           env {
#             name  = "GOOGLE_APPLICATION_CREDENTIALS"
#             value = "/config/gcloud.json"
#           }

#           command = ["/app/start.sh"]

#           volume_mount {
#             name       = "data-generation-volume"
#             mount_path = "/app/data"
#           }

#           volume_mount {
#             name       = "config"
#             mount_path = "/config"
#             read_only  = true
#           }
#         }

#       }
#     }
#   }
# }

resource "kubernetes_persistent_volume_claim" "data_generation_volume" {
  metadata {
    name      = "anaml-demo-streaming-data-generation"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "40Gi"
      }
    }
  }
}




resource "kubernetes_config_map" "producer_demo_config" {
  metadata {
    name      = "anaml-demo-streaming-data-generationr"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = {
    "application.properties" = join("\n", [ for k,v in local.kafka_config : "${k}=${v}" ])
  }
}


# data "google_secret_manager_secret_version" "producer_demo_kafka_key" {
#   secret = "producer-demo-kafka-key"
# }

# data "google_secret_manager_secret_version" "producer_demo_kafka_secret" {
#   secret = "producer-demo-kafka-secret"
# }

# data "google_secret_manager_secret_version" "producer_demo_gcloud_credentials_secret" {
#   secret = "producer-demo-gcloud-credentials"
# }

# data "google_secret_manager_secret_version" "producer_demo_schema_registry_key" {
#   secret = "producer-demo-schema-registry-key"
# }

# data "google_secret_manager_secret_version" "producer_demo_schema_registry_secret" {
#   secret = "producer-demo-schema-registry-secret"
# }

# resource "kubernetes_persistent_volume_claim" "producer_data_generation_volume" {
#   metadata {
#     name      = "producer-data-generation-volume"
#     namespace = "anaml"
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "100Mi"
#       }
#     }
#   }
# }
