locals {
  base_deployment_labels = merge({
    "app.kubernetes.io/version" = try(
      replace(regex("^sha256:[a-z0-9]{8}", var.anaml_bigquery_server_version), ":", "_"),
      var.anaml_bigquery_server_version
    )
    "app.kubernetes.io/component"  = "bigquery"
    "app.kubernetes.io/part-of"    = "anaml"
    "app.kubernetes.io/created-by" = "terraform"
  }, var.kubernetes_deployment_labels)

  anaml_bigquery_server_labels = merge(local.base_deployment_labels, {
    "app.kubernetes.io/name" = "anaml-bigquery-server"
  })

  image = (
    can(regex("^sha256:[0-9A-Za-z]+$", var.anaml_bigquery_server_version))
    ? "${var.container_registry}/anaml-bigquery-server@${var.anaml_bigquery_server_version}"
    : "${var.container_registry}/anaml-bigquery-server:${var.anaml_bigquery_server_version}"
  )

}
