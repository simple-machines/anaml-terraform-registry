resource "kubernetes_service_account" "spark" {
  metadata {
    name      = "spark"
    namespace = var.kubernetes_namespace
    labels      = { for k, v in local.anaml_spark_server_labels: k => v if ! (k == "app.kubernetes.io/version") }
  }
}

resource "kubernetes_role" "spark" {
  metadata {
    name      = "spark"
    namespace = var.kubernetes_namespace
    labels      = { for k, v in local.anaml_spark_server_labels: k => v if ! (k == "app.kubernetes.io/version") }
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "configmaps", "services"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }
}

resource "kubernetes_role_binding" "spark" {
  metadata {
    name      = "spark"
    namespace = var.kubernetes_namespace
    labels      = { for k, v in local.anaml_spark_server_labels: k => v if ! (k == "app.kubernetes.io/version") }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "spark"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.spark.metadata[0].name
    namespace = var.kubernetes_namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.service_account_name
    namespace = var.kubernetes_namespace
  }
}
