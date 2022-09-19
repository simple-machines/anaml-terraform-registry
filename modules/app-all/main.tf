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
    namespace = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  }

  data = {
    PGPASSWORD = var.postgres_password
  }
}


resource "kubernetes_service_account" "anaml" {
  count = var.kubernetes_service_account_create && var.kubernetes_service_account_name != null ? 1 : 0
  metadata {
    name        = var.kubernetes_service_account_name
    namespace   = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
    annotations = var.kubernetes_service_account_annotations
  }
}

module "anaml-docs" {
  source = "../app-docs"

  anaml_docs_version             = coalesce(var.override_anaml_docs_version, var.anaml_version)
  container_registry             = var.container_registry
  hostname                       = var.hostname
  kubernetes_namespace           = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_docs
  kubernetes_service_type        = var.kubernetes_service_type
}

module "anaml-server" {
  source = "../app-server"

  anaml_admin_email          = var.anaml_admin_email
  anaml_admin_password       = var.anaml_admin_password
  anaml_admin_secret         = var.anaml_admin_secret
  anaml_admin_token          = var.anaml_admin_token
  anaml_database_schema_name = var.override_anaml_server_anaml_database_schema_name
  anaml_server_version       = coalesce(var.override_anaml_server_version, var.anaml_version)
  container_registry         = var.container_registry
  enable_form_client         = var.enable_form_client
  governance_run_type_checks = var.override_anaml_server_governance_run_type_checks
  hostname                   = var.hostname
  kubernetes_namespace       = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector   = var.kubernetes_pod_node_selector_app

  kubernetes_container_env_from = concat(
    [{ secret_ref = { name = "postgres-secret" } }],
    var.kubernetes_container_env_from_anaml_server
  )

  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_server
  kubernetes_service_type        = var.kubernetes_service_type
  oidc_additional_scopes         = var.oidc_additional_scopes
  oidc_client_id                 = var.oidc_client_id
  oidc_client_secret             = var.oidc_client_secret
  oidc_discovery_uri             = var.oidc_discovery_uri
  oidc_enable                    = var.oidc_enable
  oidc_permitted_users_group_id  = var.oidc_permitted_users_group_id
  override_java_opts             = var.override_anaml_server_java_opts
  postgres_host                  = local.postgres_host
  postgres_password              = "$(PGPASSWORD)"
  postgres_port                  = var.postgres_port
  postgres_user                  = var.postgres_user

  kubernetes_service_account_name = var.kubernetes_service_account_create ? kubernetes_service_account.anaml[0].metadata.0.name : var.kubernetes_service_account_name

  kubernetes_pod_sidecars = var.kubernetes_pod_anaml_server_sidecars

  log4j_overrides = var.override_anaml_server_log4j_overrides

  license_key = var.license_key

  proxy_base = var.ui_base_path
}

module "anaml-ui" {
  source = "../app-ui"

  anaml_ui_version = coalesce(
    var.override_anaml_ui_version,
    var.anaml_version
  )

  api_url = coalesce(
    var.override_anaml_ui_api_url,
    join("", [var.https_urls ? "https" : "http", "://", var.hostname, var.ui_base_path == "/" ? "" : var.ui_base_path, "/api"])
  )

  basepath                       = var.ui_base_path
  container_registry             = var.container_registry
  hostname                       = var.hostname
  kubernetes_namespace           = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_ui
  kubernetes_service_type        = var.kubernetes_service_type
  skin                           = var.override_anaml_ui_skin

  docs_url                 = module.anaml-docs.internal_url
  spark_history_server_url = module.spark-server.spark_history_server_internal_url
  anaml_server_url         = module.anaml-server.internal_url
}

module "spark-server" {
  source                     = "../app-spark-server"
  kubernetes_namespace       = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  anaml_spark_server_version = coalesce(var.override_anaml_spark_server_version, var.anaml_version)
  container_registry         = var.container_registry

  additional_spark_executor_pod_templates = var.override_anaml_spark_server_additional_spark_executor_pod_templates
  additional_spark_driver_pod_templates   = var.override_anaml_spark_server_additional_spark_driver_pod_templates

  checkpoint_location = var.override_anaml_spark_server_checkpoint_location
  postgres_host       = local.postgres_host
  postgres_password   = "$(PGPASSWORD)"
  postgres_port       = var.postgres_port
  postgres_user       = var.postgres_user


  kubernetes_pod_sidecars                 = var.kubernetes_pod_anaml_spark_server_sidecars
  kubernetes_node_selector_spark_executor = var.kubernetes_pod_node_selector_spark_executor
  kubernetes_node_selector_app            = var.kubernetes_pod_node_selector_app

  kubernetes_service_account                           = var.kubernetes_service_account_create ? kubernetes_service_account.anaml[0].metadata.0.name : var.kubernetes_service_account_name
  kubernetes_service_annotations_anaml_spark_server    = var.kubernetes_service_annotations_anaml_spark_server
  kubernetes_service_annotations_spark_driver          = var.kubernetes_service_annotations_spark_driver
  kubernetes_service_annotations_spark_history_service = var.kubernetes_service_annotations_spark_history_service

  spark_config_overrides = var.override_anaml_spark_server_spark_config_overrides

  spark_log_directory = var.override_anaml_spark_server_spark_log_directory

  spark_history_server_ui_proxy_base = coalesce(
    var.override_spark_history_server_ui_proxy_base,
    var.ui_base_path == "/" ? "/spark-history" : "${var.ui_base_path}/spark-history"
  )

  kubernetes_container_spark_server_env_from = [
    # Inject the Postgres password
    { secret_ref = { name = kubernetes_secret.postgres_secret.metadata[0].name } },

    # Inject the API credentials (ANAML_ADMIN_TOKEN/ANAML_ADMIN_SECRET)
    { secret_ref = { name = module.anaml-server.anaml_admin_api_kubernetes_secret_name } }
  ]

  kubernetes_container_spark_server_env = var.override_anaml_spark_server_additional_env_values

  kubernetes_container_spark_server_volumes       = var.override_anaml_spark_server_additional_volumes
  kubernetes_container_spark_server_volume_mounts = var.override_anaml_spark_server_additional_volume_mounts

  spark_history_server_additional_env_values    = var.override_spark_history_server_additional_env_values
  spark_history_server_additional_volumes       = var.override_spark_history_server_additional_volumes
  spark_history_server_additional_volume_mounts = var.override_spark_history_server_additional_volume_mounts
  # spark_history_server_additional_env_from      = var.override_spark_history_server_additional_env_from

  log4j_overrides = var.override_anaml_spark_server_log4j_overrides

  # Use injected env_from values
  anaml_server_user     = "$(ANAML_ADMIN_TOKEN)"
  anaml_server_password = "$(ANAML_ADMIN_SECRET)"
}


module "ingress" {
  source = "../kubernetes-ingress"
  count  = var.kubernetes_ingress_enable ? 1 : 0

  host                    = var.kubernetes_ingress_hostname
  kubernetes_ingress_name = var.kubernetes_ingress_name
  kubernetes_namespace    = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
}

module "local-postgres" {
  source = "../postgres"
  count  = var.kubernetes_service_enable_postgres ? 1 : 0

  kubernetes_namespace                                  = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector                              = var.kubernetes_pod_node_selector_postgres
  kubernetes_service_annotations                        = var.kubernetes_service_annotations_postgres
  kubernetes_service_type                               = var.kubernetes_service_type
  password                                              = var.postgres_password
  user                                                  = var.postgres_user
  kubernetes_persistent_volume_claim_storage_class_name = var.kubernetes_persistent_volume_claim_storage_class_name_postgres
}
