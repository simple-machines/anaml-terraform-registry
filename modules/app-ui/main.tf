/**
 * # app-ui Terraform module
 *
 * This module deploys a Kubernetes Deployment and Service running the Anaml frontend UI web application.
 *
 * ## Terminating SSL inside the pod
 * By default Anaml UI uses plain HTTP and delegates SSL termination to Kubernetes Ingress.
 *
 * If you wish to terminate SSL inside the pod, you should:
 *
 * 1) Create a Kubernetes Secret containing the SSL certificate and key in PEM format with the names "tls.crt" for the certificate and "tls.key" for the key, either using Terraform or kubectl. Below is an example using kubectl.
 * ```
 * kubectl create secret generic anaml-ui-ssl-certs \
 *   --from-file=tls.crt=./tls.crt \
 *   --from-file=tls.key=./tls.key
 * ```
 * 2) Specify the secret using the `kubernetes_secret_ssl` anaml-ui Terraform module parameter.
 *
 * ### Notes:
 * If you do not wish to use the filenames `tls.crt` and `tls.secret` you can use the `kubernetes_deployment_container_env` anaml-ui Terraform module parameter setting `NGINX_SSL_CERTIFICATE` and `NGINX_SSL_CERTIFICATE_KEY` with the path `/certificates/MY_FILENAME` respectively where MY_FILENAME is your new name. I.e.
 *
 * ```
 * kubernetes_deployment_container_env = {
 *   NGINX_SSL_CERTIFICATE: "/certificates/anaml.crt",
 *   NGINX_SSL_CERTIFICATE_KEY: "/certificates/anaml.key"
 * }
 *
 * ```
 */

terraform {
  required_version = ">= 1.1"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.1"
    }
  }
}

locals {
  deployment_labels = merge({
    "app.kubernetes.io/name" = "anaml-ui"
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_ui_version), ":", "_"),
      var.anaml_ui_version
    )
    "app.kubernetes.io/component"   = "frontend"
    "app.kubernetes.io/part-of"     = "anaml"
    "app.kubernetes.io/created-by"  = "terraform"
    "terraform/deployment-instance" = random_uuid.deployment_instance.result
  }, var.kubernetes_deployment_labels)

  env = merge({
    "ANAML_BASEPATH" : var.basepath,
    "ANAML_API_ORIGIN_URL": "${var.anaml_server_url}/api"
    "ANAML_AUTH_ORIGIN_URL": "${var.anaml_server_url}/auth"
    "ANAML_DOCS_ORIGIN_URL" : var.docs_url,
    "REACT_APP_FRONTEND_SKIN" : var.skin,
    "SPARK_HISTORY_SERVER_ORIGIN_URL" : var.spark_history_server_url
  }, var.kubernetes_deployment_container_env)
}

# Added to allow running multiple independent instances (useful for test/development)
resource "random_uuid" "deployment_instance" {}

resource "kubernetes_deployment" "anaml_ui" {
  metadata {
    name      = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels    = local.deployment_labels
  }

  spec {
    replicas = var.kubernetes_deployment_replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name"        = local.deployment_labels["app.kubernetes.io/name"]
        "terraform/deployment-instance" = local.deployment_labels["terraform/deployment-instance"]
      }
    }

    template {
      metadata {
        labels = local.deployment_labels
      }

      spec {
        node_selector = var.kubernetes_node_selector

        container {
          name = var.kubernetes_deployment_name
          image = (
            can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_ui_version))
            ? "${var.container_registry}/anaml-ui@${var.anaml_ui_version}"
            : "${var.container_registry}/anaml-ui:${var.anaml_ui_version}"
          )
          image_pull_policy = var.kubernetes_image_pull_policy
          port {
            container_port = 80
            name           = "http-web-svc"
          }

          dynamic "env" {
            for_each = local.env
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "volume_mount" {
            for_each = var.kubernetes_secret_ssl == null ? [] : [var.kubernetes_secret_ssl]
            content {
              name = volume_mount.value
              mount_path = "/certificates"
              read_only = true
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }

            period_seconds  = 5
            timeout_seconds = 5
          }
        }

        dynamic "volume" {
          for_each = var.kubernetes_secret_ssl == null ? [] : [var.kubernetes_secret_ssl]
          content {
            secret {
              secret_name = volume.value
              optional = "false"
              default_mode = "0444"
            }
          }
        }

      }
    }
  }

  timeouts {
    create = "5m"
  }
}

resource "kubernetes_service" "anaml_ui" {
  metadata {
    name        = var.kubernetes_deployment_name
    namespace   = var.kubernetes_namespace
    labels      = { for k, v in local.deployment_labels : k => v if k != "app.kubernetes.io/version" }
    annotations = var.kubernetes_service_annotations
  }

  spec {
    type = var.kubernetes_service_type
    selector = {
      "app.kubernetes.io/name"        = local.deployment_labels["app.kubernetes.io/name"]
      "terraform/deployment-instance" = local.deployment_labels["terraform/deployment-instance"]
    }
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "http-web-svc"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["cloud.google.com/neg-status"]]
  }
}
