terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
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

module "anaml-docs" {
  source = "../anaml-docs"

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
  source = "../anaml-server"

  anaml_admin_email              = var.anaml_admin_email
  anaml_admin_password           = var.anaml_admin_password
  anaml_admin_secret             = var.anaml_admin_secret
  anaml_admin_token              = var.anaml_admin_token
  anaml_database_schema_name     = var.override_anaml_server_anaml_database_schema_name
  anaml_external_domain          = var.hostname
  anaml_server_version           = var.override_anaml_server_version != null ? var.override_anaml_server_version : var.anaml_version
  container_registry             = var.container_registry
  enable_form_client             = var.enable_form_client
  kubernetes_namespace           = var.kubernetes_namespace_name
  kubernetes_node_selector       = var.kubernetes_pod_node_selector_app
  kubernetes_secret_refs         = ["postgres-secret"]
  kubernetes_service_annotations = var.kubernetes_service_annotations_anaml_server
  kubernetes_service_type        = var.kubernetes_service_type
  oidc_additional_scopes         = var.oidc_additional_scopes
  oidc_client_id                 = var.oidc_client_id
  oidc_client_secret             = var.oidc_client_secret
  oidc_discovery_uri             = var.oidc_discovery_uri
  oidc_enable                    = var.oidc_enable
  oidc_permitted_users_group_id  = var.oidc_permitted_users_group_id
  postgres_host                  = var.kubernetes_service_enable_postgres ? "postgres.${var.kubernetes_namespace_name}.svc.cluster.local" : var.postgres_host
  postgres_password              = "$(PGPASSWORD)"
  postgres_port                  = var.postgres_port
  postgres_user                  = var.postgres_user

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "anaml-ui" {
  source = "../anaml-ui"

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

  depends_on = [kubernetes_namespace.anaml_namespace]
}

module "ingress" {
  source = "../anaml-kubernetes-ingress"
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
