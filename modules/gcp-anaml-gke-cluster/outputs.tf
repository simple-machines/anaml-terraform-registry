output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke_cluster.ca_certificate
}

output "cluster_id" {
  description = "Cluster ID"
  value       = module.gke_cluster.cluster_id
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke_cluster.endpoint
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.gke_cluster.horizontal_pod_autoscaling_enabled
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.gke_cluster.http_load_balancing_enabled
}

output "identity_namespace" {
  description = "Workload Identity pool"
  value       = module.gke_cluster.identity_namespace
}

output "instance_group_urls" {
  description = "List of GKE generated instance groups"
  value       = module.gke_cluster.instance_group_urls
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke_cluster.location
}

output "logging_service" {
  description = "Logging service used"
  value       = module.gke_cluster.logging_service
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.gke_cluster.master_version
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = module.gke_cluster.min_master_version
}

output "name" {
  description = "Cluster name"
  value       = module.gke_cluster.name
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.gke_cluster.network_policy_enabled
}

output "region" {
  description = "Cluster region"
  value       = module.gke_cluster.region
}

output "release_channel" {
  description = "The release channel of this cluster"
  value       = module.gke_cluster.release_channel
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.gke_cluster.service_account
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = module.gke_cluster.type
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke_cluster.zones
}
