output "spark_preview_cluster_name" {
  value = anaml-operations_cluster.spark_on_k8s_preview_cluster.name
}

output "spark_job_cluster_name" {
  value = anaml-operations_cluster.spark_on_k8s_job_cluster.name
}

output "spark_job_event_store_cluster_name" {
  value = anaml-operations_cluster.event_store_cluster.name
}
