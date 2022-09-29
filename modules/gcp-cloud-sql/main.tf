terraform {
  required_version = ">= 1.1"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53.0, < 5.0.0"
    }
  }
}

resource "random_id" "anaml_db_name_suffix" {
  for_each    = toset(var.postgresql_deploy_versions)
  byte_length = 4
}

resource "google_sql_database_instance" "anaml_postgres_instance" {
  for_each         = toset(var.postgresql_deploy_versions)
  name             = "${var.name_prefix}${random_id.anaml_db_name_suffix[each.key].hex}"
  region           = var.region
  database_version = "POSTGRES_${each.key}"
  settings {
    tier      = var.tier
    disk_size = var.disk_size
    ip_configuration {
      ipv4_enabled    = var.ip_configuration_ipv4_enabled
      private_network = var.ip_configuration_private_network_id
    }
    insights_config {
      query_insights_enabled  = var.insights_config_query_insights_enabled
      query_string_length     = var.insights_config_query_string_length
      record_application_tags = var.insights_config_record_application_tags
      record_client_address   = var.insights_config_record_client_address
    }
  }

  deletion_protection = var.deletion_protection
  project             = var.project_name
}


resource "google_sql_database" "anaml" {
  for_each = toset(var.postgresql_deploy_versions)

  name     = "anaml"
  instance = google_sql_database_instance.anaml_postgres_instance[each.key].name
}

resource "google_sql_user" "users" {
  for_each        = toset(var.postgresql_deploy_versions)
  name            = var.user
  instance        = google_sql_database_instance.anaml_postgres_instance[each.key].name
  password        = var.password
  deletion_policy = "ABANDON"
}
