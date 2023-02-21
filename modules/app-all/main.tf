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
  kubernetes_secret_ssl          = var.override_anaml_docs_kubernetes_secret_ssl
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_docs
  kubernetes_service_type        = var.kubernetes_service_type

  rebrand = var.override_anaml_docs_rebrand
}

module "anaml-server" {
  source = "../app-server"

  anaml_admin_email           = var.anaml_admin_email
  anaml_admin_password        = var.anaml_admin_password
  anaml_admin_secret          = var.anaml_admin_secret
  anaml_admin_token           = var.anaml_admin_token
  anaml_database_schema_name  = var.override_anaml_server_anaml_database_schema_name
  anaml_server_version        = coalesce(var.override_anaml_server_version, var.anaml_version)
  container_registry          = var.container_registry
  enable_form_client          = var.enable_form_client
  enable_header_debug_logging = var.override_anaml_server_enable_header_debug_logging
  enable_body_debug_logging   = var.override_anaml_server_enable_body_debug_logging
  governance_run_type_checks  = var.override_anaml_server_governance_run_type_checks
  hostname                    = var.hostname
  kubernetes_namespace        = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector    = var.kubernetes_pod_node_selector_app

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

  kubernetes_security_context = var.override_anaml_server_kubernetes_security_context

  kubernetes_service_account_name = coalesce(
    var.override_anaml_server_kubernetes_service_account,
    var.kubernetes_service_account_create ? kubernetes_service_account.anaml[0].metadata.0.name : var.kubernetes_service_account_name
  )

  kubernetes_pod_sidecars = var.kubernetes_pod_anaml_server_sidecars


  ssl_kubernetes_secret_pkcs12_truststore              = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_truststore
  ssl_kubernetes_secret_pkcs12_truststore_key          = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_truststore_key
  ssl_kubernetes_secret_pkcs12_truststore_password     = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_truststore_password
  ssl_kubernetes_secret_pkcs12_truststore_password_key = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_truststore_password_key

  ssl_kubernetes_secret_pkcs12_keystore              = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_keystore
  ssl_kubernetes_secret_pkcs12_keystore_key          = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_keystore_key
  ssl_kubernetes_secret_pkcs12_keystore_password     = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_keystore_password
  ssl_kubernetes_secret_pkcs12_keystore_password_key = var.override_anaml_server_ssl_kubernetes_secret_pkcs12_keystore_password_key


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

  basepath = var.ui_base_path
  container_registry = coalesce(
    var.override_anaml_ui_container_registry,
    var.container_registry
  )
  container_image_name                = var.override_anaml_ui_container_image_name
  kubernetes_deployment_container_env = var.override_anaml_ui_kubernetes_deployment_container_env
  kubernetes_namespace                = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  kubernetes_node_selector            = var.kubernetes_pod_node_selector_app
  kubernetes_secret_ssl               = var.override_anaml_ui_kubernetes_secret_ssl
  kubernetes_service_annotations      = var.kubernetes_service_annotations_anaml_ui
  kubernetes_service_type             = var.kubernetes_service_type
  language                            = var.override_anaml_language
  skin                                = var.override_anaml_ui_skin

  docs_url                 = module.anaml-docs.internal_url
  spark_history_server_url = module.spark-server.spark_history_server_internal_url
  anaml_server_url         = module.anaml-server.internal_url
}

module "spark-server" {
  source                     = "../app-spark-server"
  kubernetes_namespace       = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name
  anaml_spark_server_version = coalesce(var.override_anaml_spark_server_version, var.anaml_version)
  container_registry         = var.container_registry

  checkpoint_location = var.override_anaml_spark_server_checkpoint_location

  enable_spark_history_server = var.enable_spark_history_server

  postgres_host     = local.postgres_host
  postgres_password = "$(PGPASSWORD)"
  postgres_port     = var.postgres_port
  postgres_user     = var.postgres_user

  kubernetes_container_resources_requests_cpu    = var.override_anaml_spark_server_kubernetes_container_resources_requests_cpu
  kubernetes_container_resources_requests_memory = var.override_anaml_spark_server_kubernetes_container_resources_requests_memory
  kubernetes_container_resources_limits_cpu      = var.override_anaml_spark_server_kubernetes_container_resources_limits_cpu
  kubernetes_container_resources_limits_memory   = var.override_anaml_spark_server_kubernetes_container_resources_limits_memory

  kubernetes_pod_sidecars                 = var.kubernetes_pod_anaml_spark_server_sidecars
  kubernetes_node_selector_spark_executor = var.kubernetes_pod_node_selector_spark_executor
  kubernetes_node_selector_app            = var.kubernetes_pod_node_selector_app

  kubernetes_service_account_deployment = coalesce(
    var.override_anaml_spark_server_kubernetes_service_account,
    var.kubernetes_service_account_create ? kubernetes_service_account.anaml[0].metadata.0.name : var.kubernetes_service_account_name
  )

  kubernetes_service_annotations_anaml_spark_server    = var.kubernetes_service_annotations_anaml_spark_server
  kubernetes_service_annotations_spark_history_service = var.kubernetes_service_annotations_spark_history_service

  spark_config_overrides = var.override_anaml_spark_server_spark_config_overrides

  spark_cluster_configs = var.override_anaml_spark_server_spark_cluster_configs

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

  kubernetes_deployment_name = var.override_anaml_spark_server_kubernetes_deployment_name

  kubernetes_service_account_spark_driver_executor             = var.override_anaml_spark_server_kubernetes_service_account_spark_driver_executor
  kubernetes_service_account_spark_driver_executor_create      = var.override_anaml_spark_server_kubernetes_service_account_spark_driver_executor_create
  kubernetes_service_account_spark_driver_executor_annotations = var.override_anaml_spark_server_kubernetes_service_account_spark_driver_executor_annotations

  ssl_kubernetes_secret_pkcs12_truststore              = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_truststore
  ssl_kubernetes_secret_pkcs12_truststore_key          = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_truststore_key
  ssl_kubernetes_secret_pkcs12_truststore_password     = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_truststore_password
  ssl_kubernetes_secret_pkcs12_truststore_password_key = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_truststore_password_key

  ssl_kubernetes_secret_pkcs12_keystore              = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_keystore
  ssl_kubernetes_secret_pkcs12_keystore_key          = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_keystore_key
  ssl_kubernetes_secret_pkcs12_keystore_password     = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_keystore_password
  ssl_kubernetes_secret_pkcs12_keystore_password_key = var.override_anaml_spark_server_ssl_kubernetes_secret_pkcs12_keystore_password_key


  spark_history_server_additional_env_values    = var.override_spark_history_server_additional_env_values
  spark_history_server_additional_volumes       = var.override_spark_history_server_additional_volumes
  spark_history_server_additional_volume_mounts = var.override_spark_history_server_additional_volume_mounts
  # spark_history_server_additional_env_from      = var.override_spark_history_server_additional_env_from

  spark_history_server_additional_spark_history_opts = var.override_spark_history_server_additional_spark_history_opts

  log4j_overrides = var.override_anaml_spark_server_log4j_overrides

  # Use injected env_from values
  anaml_server_user     = "$(ANAML_ADMIN_TOKEN)"
  anaml_server_password = "$(ANAML_ADMIN_SECRET)"

  anaml_server_url = module.anaml-server.internal_url
}


module "ingress" {
  source = "../kubernetes-ingress"
  count  = var.kubernetes_ingress_enable ? 1 : 0

  host                                = var.kubernetes_ingress_hostname
  kubernetes_ingress_additional_paths = var.kubernetes_ingress_additional_paths
  kubernetes_ingress_annotations      = var.kubernetes_ingress_annotations
  kubernetes_ingress_name             = var.kubernetes_ingress_name
  kubernetes_ingress_tls_hosts        = var.kubernetes_ingress_tls_hosts
  kubernetes_ingress_tls_secret_name  = var.kubernetes_ingress_tls_secret_name
  kubernetes_namespace                = var.kubernetes_namespace_create ? kubernetes_namespace.anaml_namespace[0].metadata.0.name : var.kubernetes_namespace_name

  anaml_server_port = module.anaml-server.kubernetes_service_port_number
  anaml_docs_port   = module.anaml-docs.kubernetes_service_port_number
  anaml_ui_port     = module.anaml-ui.kubernetes_service_port_number
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
