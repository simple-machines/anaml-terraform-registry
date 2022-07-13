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

resource "google_compute_health_check" "http_80" {
  name        = "health-check"
  timeout_sec = 5

  http_health_check {
    port = 80
  }
}

resource "google_compute_health_check" "http_8080" {
  name        = "health-check-http-8080"
  timeout_sec = 5

  http_health_check {
    port = 8080
  }
}

resource "google_compute_health_check" "http_18080" {
  name        = "health-check-http-18080"
  timeout_sec = 30
  check_interval_sec = 60
  healthy_threshold = 1

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }

  log_config {
    enable = true
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
  for_each = merge (
    { for deployment in var.deployments: "anaml-${deployment}-docs" => google_compute_health_check.http_80.id },
    { for deployment in var.deployments: "anaml-${deployment}-ui" => google_compute_health_check.http_80.id },
    { for deployment in var.deployments: "anaml-${deployment}-server" => google_compute_health_check.http_8080.id },
    { for deployment in var.deployments: "${deployment}-spark-history-server" => google_compute_health_check.http_18080.id }
  )


  name = each.key
  health_checks = [each.value]

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
