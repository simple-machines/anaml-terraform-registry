resource "kubernetes_config_map" "anaml_bigquery_server_config" {
  metadata {
    name      = "anaml-bigquery-server-config"
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_bigquery_server_labels : k => v if k != "app.kubernetes.io/version" }
  }

  data = merge(

    {},

    {
      "application.conf" = templatefile("${path.module}/_templates/application.conf", {
        anamlServerUrl     = var.anaml_server_url

        anamlServerUsername = try(
          // Allow Kubernetes style values and convert to Typesafe config format
          format("$${?%s}", one(regex("^\\$\\((\\w+)\\)$", var.anaml_server_user))),

          // Allow standard Typesafe config values and pass through as is
          format("%s", regex("^\\$\\{\\??\\w+\\}$", var.anaml_server_user)),

          // Allow string values
          format("\"%s\"", var.anaml_server_user),

          // If all else fails or is null
          var.anaml_server_user
        )

        anamlServerPassword = try(
          // Allow Kubernetes style values and convert to Typesafe config format
          format("$${?%s}", one(regex("^\\$\\((\\w+)\\)$", var.anaml_server_password))),

          // Allow standard Typesafe config values and pass through as is
          format("%s", regex("^\\$\\{\\??\\w+\\}$", var.anaml_server_password)),

          // Allow string values
          format("\"%s\"", var.anaml_server_password),

          // If all else fails or is null
          var.anaml_server_password
        ),

        truststore              = var.ssl_kubernetes_secret_pkcs12_truststore != null ? "/tmp/certificates/java/truststore" : null,
        use_truststore_password = var.ssl_kubernetes_secret_pkcs12_truststore_password != null,

        keystore              = var.ssl_kubernetes_secret_pkcs12_keystore != null ? "/tmp/certificates/java/keystore" : null,
        use_keystore_password = var.ssl_kubernetes_secret_pkcs12_keystore_password != null,

        loggers = {} #merge(local.default_log4j_loggers, var.log4j_overrides)

        bigquery_default_dataset = var.bigquery_default_dataset
      })

     }
  )
}

