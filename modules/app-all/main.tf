/**
 * # app-all Terraform module
 *
 * The app-docs Terraform module deploys the full suite of Anaml applications to Kubernetes.
 *  - [anaml-docs](../app-docs)
 *  - [anaml-server](../app-server)
 *  - [anaml-ui](../app-ui)
 *  - [ingress](../kubernetes-ingress) - Optional Kubernetes Ingress setup. See the [kubernetes_ingress_enable](#input_kubernetes_ingress_enable) option below
 *  - [local-postgres](../postgres) - Optional Postgres Kubernetes stateful set. This is only recommended for dev/test. See the [kubernetes_service_enable_postgres](#input_kubernetes_service_enable_postgres) option below
 *  - [spark-server](../app-spark-server)
 */


terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }

  experiments = [module_variable_optional_attrs]
}

locals {
  postgres_host = var.kubernetes_service_enable_postgres ? "postgres.${var.kubernetes_namespace_name}.svc.cluster.local" : var.postgres_host
}

resource "kubernetes_namespace" "anaml_namespace" {
  count = var.kubernetes_namespace_create ? 1 : 0
  metadata {
    name = var.kubernetes_namespace_name
    labels = {
      name = var.kubernetes_namespace_name
    }
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = var.kubernetes_namespace_name
  }

  data = {
    PGPASSWORD = var.postgres_password
  }

  depends_on = [kubernetes_namespace.anaml_namespace]
}


resource "kubernetes_service_account" "anaml" {
  count = var.kubernetes_service_account_create && var.kubernetes_service_account_name != null ? 1 : 0
  metadata {
    name        = var.kubernetes_service_account_name
    namespace   = var.kubernetes_namespace_name
    annotations = var.kubernetes_service_account_annotations
  }

}

module "anaml-docs" {
  source = "../app-docs"

  anaml_docs_version             = var.override_anaml_docs_version != null ? var.override_anaml_docs_version : var.anaml_version
  container_registry             = var.container_registry
  hostname                       = var.hostname
  kubernetes_namespace           = var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_docs
  kubernetes_service_type        = var.kubernetes_service_type

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "anaml-server" {
  source = "../app-server"

  anaml_admin_email              = var.anaml_admin_email
  anaml_admin_password           = var.anaml_admin_password
  anaml_admin_secret             = var.anaml_admin_secret
  anaml_admin_token              = var.anaml_admin_token
  anaml_database_schema_name     = var.override_anaml_server_anaml_database_schema_name
  anaml_server_version           = var.override_anaml_server_version != null ? var.override_anaml_server_version : var.anaml_version
  container_registry             = var.container_registry
  enable_form_client             = var.enable_form_client
  hostname                       = var.hostname
  kubernetes_namespace           = var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_container_env_from  = [
    { secret_ref = { name = "postgres-secret" } }
  ]
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_server
  kubernetes_service_type        = var.kubernetes_service_type
  oidc_additional_scopes         = var.oidc_additional_scopes
  oidc_client_id                 = var.oidc_client_id
  oidc_client_secret             = var.oidc_client_secret
  oidc_discovery_uri             = var.oidc_discovery_uri
  oidc_enable                    = var.oidc_enable
  oidc_permitted_users_group_id  = var.oidc_permitted_users_group_id
  postgres_host                  = local.postgres_host
  postgres_password              = "$(PGPASSWORD)"
  postgres_port                  = var.postgres_port
  postgres_user                  = var.postgres_user

  kubernetes_service_account_name = var.kubernetes_service_account_name

  kubernetes_pod_sidecars = var.kubernetes_pod_anaml_server_sidecars

  license_key = var.license_key

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "anaml-ui" {
  source = "../app-ui"

  anaml_ui_version               = var.override_anaml_ui_version != null ? var.override_anaml_ui_version : var.anaml_version
  api_url                        = var.override_anaml_ui_api_url != null ? var.override_anaml_ui_api_url : join("", [var.https_urls ? "https" : "http", "://", var.hostname, "/api"])
  container_registry             = var.container_registry
  enable_new_functionality       = var.override_anaml_ui_enable_new_functionality
  hostname                       = var.hostname
  kubernetes_namespace           = var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_ui
  kubernetes_service_type        = var.kubernetes_service_type
  skin                           = var.override_anaml_ui_skin

  # TODO
  docs_url                 = "http://example.com"
  spark_history_server_url = "http://example.com"
  anaml_server_url         = "http://anaml-server.${var.kubernetes_namespace_name}.svc.cluster.local:8080"

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "spark-server" {
  source                     = "../app-spark-server"
  kubernetes_namespace       = var.kubernetes_namespace_name
  anaml_spark_server_version = var.override_anaml_spark_server_version != null ? var.override_anaml_spark_server_version : var.anaml_version
  container_registry         = var.container_registry

  checkpoint_location = var.override_anaml_spark_server_checkpoint_location
  postgres_host       = local.postgres_host
  postgres_port       = var.postgres_port
  postgres_password   = "$(PGPASSWORD)"


  kubernetes_pod_sidecars                 = var.kubernetes_pod_anaml_spark_server_sidecars
  kubernetes_node_selector_spark_executor = var.kubernetes_pod_node_selector_spark_executor
  kubernetes_node_selector_app            = var.kubernetes_pod_node_selector_app

  kubernetes_service_annotations_anaml_spark_server    = var.kubernetes_service_annotations_anaml_spark_server
  kubernetes_service_annotations_spark_driver          = var.kubernetes_service_annotations_spark_driver
  kubernetes_service_annotations_spark_history_service = var.kubernetes_service_annotations_spark_history_service

  spark_config_overrides = var.override_anaml_spark_server_spark_config_overrides

  spark_log_directory = var.override_anaml_spark_server_spark_log_directory


  additional_env_from = [
    # Inject the Postgres password
    { secret_ref = { name = kubernetes_secret.postgres_secret.metadata[0].name } }
  ]

  additional_env_values = var.override_anaml_spark_server_additional_env_values

  additional_volumes       = var.override_anaml_spark_server_additional_volumes
  additional_volume_mounts = var.override_anaml_spark_server_additional_volume_mounts

  spark_history_server_additional_env_values    = var.override_spark_history_server_additional_env_values
  spark_history_server_additional_volumes       = var.override_spark_history_server_additional_volumes
  spark_history_server_additional_volume_mounts = var.override_spark_history_server_additional_volume_mounts
  # spark_history_server_additional_env_from      = var.override_spark_history_server_additional_env_from


  # Use creds from the pod environment - TODO (spark server module should set these as default)
  anaml_server_user     = "$${?ANAML_ADMIN_TOKEN}"
  anaml_server_password = "$${?ANAML_ADMIN_SECRET}"

  depends_on = [kubernetes_namespace.anaml_namespace]
}


module "ingress" {
  source = "../kubernetes-ingress"
  count  = var.kubernetes_ingress_enable ? 1 : 0

  host                    = var.kubernetes_ingress_hostname
  kubernetes_ingress_name = var.kubernetes_ingress_name
  kubernetes_namespace    = var.kubernetes_namespace_name

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "local-postgres" {
  source = "../postgres"
  count  = var.kubernetes_service_enable_postgres ? 1 : 0

  kubernetes_namespace                                  = var.kubernetes_namespace_name
  kubernetes_node_selector                              = var.kubernetes_pod_node_selector_postgres
  kubernetes_service_annotations                        = var.kubernetes_service_annotations_postgres
  kubernetes_service_type                               = var.kubernetes_service_type
  password                                              = var.postgres_password
  user                                                  = var.postgres_user
  kubernetes_persistent_volume_claim_storage_class_name = var.kubernetes_persistent_volume_claim_storage_class_name_postgres

  depends_on = [kubernetes_namespace.anaml_namespace]
}
