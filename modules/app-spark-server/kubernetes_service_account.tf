resource "kubernetes_service_account" "default" {
  count = var.kubernetes_service_account_spark_driver_executor_create ? 1 : 0
  metadata {
    name        = var.kubernetes_service_account_spark_driver_executor
    namespace   = var.kubernetes_namespace
    labels      = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
    annotations = var.kubernetes_service_account_spark_driver_executor_annotations
  }
}

resource "kubernetes_role" "default" {
  metadata {
    name      = var.kubernetes_role_spark_driver_executor_name
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "configmaps", "services", "persistentvolumeclaims"]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "watch"
    ]
  }
}

resource "kubernetes_role_binding" "spark" {
  metadata {
    name      = var.kubernetes_role_spark_driver_executor_name
    namespace = var.kubernetes_namespace
    labels    = { for k, v in local.anaml_spark_server_labels : k => v if k != "app.kubernetes.io/version" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.kubernetes_role_spark_driver_executor_name
  }

  dynamic "subject" {
    for_each = toset(compact([var.kubernetes_service_account_deployment, var.kubernetes_service_account_spark_driver_executor]))

    content {
      kind      = "ServiceAccount"
      name      = subject.value
      namespace = var.kubernetes_namespace
    }
  }
}
