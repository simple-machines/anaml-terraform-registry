/**
 * # gcp-global-shared-lb
 *
 * > :warning: It's likely you do not want to deploy this!
 *
 * ## What is it?
 *
 * This module is for multi-tenant environments allowing a GKE cluster serving multiple instances of Anaml to use a single GCP Global Loadbalancer for routing instead of a Loadbalancer per deployment if using standard Kubernetes Ingress.
 *
 * This module relies on Google Clouds and GKE built in Network Endpoint Group (NEG) functionality.
 *
 * To use this module deployments need to be annotated with `cloud.google.com/neg` annotations. See the below example:
 *
 * ```
 * locals {
 *   dns_zone    = "nonprod.anaml.app"
 *   name_prefix = "anaml-nonprod"
 *   network     = "anaml-vpc"
 *
 *   deployments = {
 *     "dev" = {
 *       override_anaml_docs_version                = "v1.5.4-5-g645ac24"
 *       override_anaml_server_version              = "v1.5.4-31-gb15f5a72"
 *       override_anaml_ui_api_url                  = "v1.5.4-13-gaff59c3b"
 *       override_anaml_ui_enable_new_functionality = true
 *       version                                    = "v1.5.4"
 *       ...
 *     },
 *     "test" = {
 *       ...
 *     }
 *   }
 * }
 *
 *
 * module "deployments" {
 *   source = "git@github.com:simple-machines/anaml-terraform-registry.git/modules//app-all"
 *
 *   for_each = local.deployments
 *
 *   # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
 *   kubernetes_service_annotations_anaml_docs = merge(
 *     { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "80" : { name : "anaml-${each.key}-docs" } } }) },
 *     try(each.value.kubernetes_service_annotations_anaml_docs, {})
 *   )
 *
 *   # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
 *   kubernetes_service_annotations_anaml_server = merge(
 *     { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "8080" : { name : "anaml-${each.key}-server" } } }) },
 *     try(each.value.kubernetes_service_annotations_anaml_server, {})
 *   )
 *
 *   # Inject GCP specific annotations for deterministic Network Endpoint Group (NEG) names we can reference in the global loadbalancer
 *   kubernetes_service_annotations_anaml_ui = merge(
 *     { "cloud.google.com/neg" = jsonencode({ exposed_ports : { "80" : { name : "anaml-${each.key}-ui" } } }) },
 *     try(each.value.kubernetes_service_annotations_anaml_ui, {})
 *   )
 *
 *   ...
 * }
 * ```
 */

terraform {
  required_version = ">= 1.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
  }
}

resource "google_compute_global_address" "loadbalancer" {
  name        = "${var.name_prefix}-loadbalancer"
  description = "Public IP address to use for anaml loadbalancer"
}

# Allow GCP Loadbalancer talk to the Kubernetes cluster Network Endpoint Groups (NEGs)
# ref https://cloud.google.com/kubernetes-engine/docs/how-to/standalone-neg#attaching-ext-https-lb
resource "google_compute_firewall" "default" {
  name          = "${var.name_prefix}-gke-loadbalancer-neg-access"
  network       = var.network
  direction     = "INGRESS"
  target_tags   = var.target_tags
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "18080"] # Only allow HTTP services (18080 is spark-history-server ui)
  }
}

resource "google_compute_health_check" "default" {
  name               = "health-check-gke-http-serving-port"
  timeout_sec        = 10
  check_interval_sec = 30
  healthy_threshold  = 1

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }

  log_config {
    enable = var.enable_health_check_logging
  }
}

# TODO - replace with wildcard dns using Google Certificate Manager when https://github.com/hashicorp/terraform-provider-google/issues/11037 is resolved
# This means we do not need to manually edit dns, we can create a wildcard record and certs will just work
resource "google_compute_managed_ssl_certificate" "default" {
  name        = var.name_prefix
  description = "*.${var.dns_zone}"
  managed {
    # It's easier to pass the list of domains instead of wildcard as wildcard requires DNS challenges
    domains = formatlist("%s.${var.dns_zone}", var.deployments)
  }
}



# For each deployment, create the matching docs, server and ui anaml loadbalancer backends
resource "google_compute_backend_service" "backends" {
  for_each = merge(
    { for deployment in var.deployments : "anaml-${deployment}-docs" => {
      health_checks = [google_compute_health_check.default.id]
      security_policy = var.anaml_docs_security_policy
    }},

    { for deployment in var.deployments : "anaml-${deployment}-ui" => {
      health_checks = [google_compute_health_check.default.id]
      security_policy = var.anaml_ui_security_policy
    }},

    { for deployment in var.deployments : "anaml-${deployment}-server" => {
      health_checks = [google_compute_health_check.default.id],
      security_policy = var.anaml_server_security_policy
      timeout_sec = 1800
    }},

    { for deployment in var.deployments : "${deployment}-spark-history-server" => {
      health_checks = [google_compute_health_check.default.id]
      security_policy = var.spark_history_server_security_policy
    }}
  )


  name          = each.key
  health_checks = each.value.health_checks
  timeout_sec   = try(each.value.timeout_sec, 30)
  security_policy = each.value.security_policy

  log_config {
    enable = var.enable_backend_logging
  }

  backend {
    # TODO parameterise group zone/negs. Currently hardcoded for dev testing purposes
    group                 = "https://www.googleapis.com/compute/v1/projects/${var.gcp_project_name}/zones/${var.deployment_zone}/networkEndpointGroups/${each.key}"
    balancing_mode        = "RATE"
    max_rate_per_endpoint = 5
  }
}


resource "google_compute_url_map" "urlmap" {
  name            = var.name_prefix
  default_service = var.default_service

  dynamic "host_rule" {
    for_each = toset(var.deployments)
    content {
      hosts        = ["${host_rule.key}.${var.dns_zone}"]
      path_matcher = host_rule.key
    }
  }

  dynamic "path_matcher" {
    for_each = toset(var.deployments)
    content {
      name            = path_matcher.key
      default_service = "anaml-${path_matcher.key}-ui"
      path_rule {
        paths   = ["/docs/*"]
        service = "anaml-${path_matcher.key}-docs"
      }
      path_rule {
        paths   = ["/api/*"]
        service = "anaml-${path_matcher.key}-server"
      }
      path_rule {
        paths   = ["/auth/*"]
        service = "anaml-${path_matcher.key}-server"
      }
      path_rule {
        paths   = ["/spark-history", "/spark-history/*"]
        service = "${path_matcher.key}-spark-history-server"
        route_action {
          url_rewrite {
            path_prefix_rewrite = "/"
          }
        }
      }
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = var.name_prefix
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
  url_map          = google_compute_url_map.urlmap.id
}

resource "google_compute_global_forwarding_rule" "google_compute_forwarding_rule" {
  name       = "${var.name_prefix}-l7-lb-forwarding-rule"
  ip_address = google_compute_global_address.loadbalancer.id
  port_range = "443"
  target     = google_compute_target_https_proxy.default.id
}
