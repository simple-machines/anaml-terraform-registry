output "spark_preview_cluster_name" {
  value = {
    name = anaml-operations_cluster.spark_on_k8s_preview_cluster.name
    id = anaml-operations_cluster.spark_on_k8s_preview_cluster.id
  }
}

output "spark_job_cluster" {
  value = {
    name = anaml-operations_cluster.spark_on_k8s_job_cluster.name
    id = anaml-operations_cluster.spark_on_k8s_job_cluster.id
  }
}


output "spark_job_event_store_cluster_name" {
  value = {
    name = anaml-operations_cluster.event_store_cluster.name
    id = anaml-operations_cluster.event_store_cluster.id
  }
}
