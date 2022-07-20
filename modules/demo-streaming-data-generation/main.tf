# TODO - file created as a note to seld
# See: https://github.com/simple-machines/anaml-devops/blob/master/terraform/gcp/4_demo_data/modules/data_generation/kubernetes.tf

# resource "kubernetes_deployment" "kafka_data_generator" {
#   metadata {
#     name      = "anaml-producer-demo"
#     namespace = "anaml"
#     labels = {
#       name = "anaml-producer-demo"
#     }
#   }
#   spec {
#     selector {
#       match_labels = {
#         app = "anaml-producer-demo"
#       }
#     }
#     template {
#       metadata {
#         name      = "anaml-producer-demo"
#         namespace = "anaml"
#         labels = {
#           name = "anaml-producer-demo"
#           app  = "anaml-producer-demo"
#         }
#       }
#       spec {
#         service_account_name = "svc-data-generator"
#         volume {
#           name = "config"
#           config_map {
#             name = kubernetes_config_map.producer_demo_config.metadata.0.name
#           }
#         }
#         node_selector = {
#           node_pool = "anaml-node-pool"
#         }
#         container {
#           name              = "anaml-producer-demo"
#           image             = "${var.gcr_repository_url}/anaml-producer-demo:latest"
#           image_pull_policy = "Always"
#           env {
#             name  = "ANAML_GS_PROJECT_ID"
#             value = var.project_name
#           }
#           env {
#             name  = "ANAML_GS_BUCKET"
#             value = "anaml-dev-warehouse"
#           }
#           env {
#             name  = "GS_CUSTOMER_SOURCE_PATH"
#             value = "vapour/customers"
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
#         volume {
#           name = "data-generation-volume"
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim.producer_data_generation_volume.metadata.0.name
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_config_map" "producer_demo_config" {
#   metadata {
#     name      = "producer-demo-config"
#     namespace = "anaml"
#   }

#   data = {
#     "application.properties" = <<EOF
# # Required connection configs for Kafka producer, consumer, and admin
# bootstrap.servers=${var.bootstrap_server}
# security.protocol=SASL_SSL
# sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='${data.google_secret_manager_secret_version.producer_demo_kafka_key.secret_data}' password='${data.google_secret_manager_secret_version.producer_demo_kafka_secret.secret_data}';
# sasl.mechanism=PLAIN
# key.serializer=org.apache.kafka.common.serialization.VoidSerializer
# value.serializer=io.confluent.kafka.serializers.KafkaAvroSerializer
# schema.registry.url=https://psrc-41vyv.australia-southeast1.gcp.confluent.cloud
# basic.auth.credentials.source=USER_INFO
# basic.auth.user.info=${data.google_secret_manager_secret_version.producer_demo_schema_registry_key.secret_data}:${data.google_secret_manager_secret_version.producer_demo_schema_registry_secret.secret_data}
# acks=all
#     EOF

#     "gcloud.json" = data.google_secret_manager_secret_version.producer_demo_gcloud_credentials_secret.secret_data
#   }
# }


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
