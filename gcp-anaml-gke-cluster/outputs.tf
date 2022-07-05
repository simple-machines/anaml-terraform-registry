output "ca_certificate" {
  value = module.gke_cluster.ca_certificate
}

output "cluster_id" {
  value = module.gke_cluster.cluster_id
}

output "endpoint" {
  value = module.gke_cluster.endpoint
}

output "horizontal_pod_autoscaling_enabled" {
  value = module.gke_cluster.horizontal_pod_autoscaling_enabled
}

output "http_load_balancing_enabled" {
  value = module.gke_cluster.http_load_balancing_enabled
}

output "identity_namespace" {
  value = module.gke_cluster.identity_namespace
}

output "instance_group_urls" {
  value = module.gke_cluster.instance_group_urls
}

output "location" {
  value = module.gke_cluster.location
}

output "logging_service" {
  value = module.gke_cluster.logging_service
}

output "master_version" {
  value = module.gke_cluster.master_version
}

output "min_master_version" {
  value = module.gke_cluster.min_master_version
}

output "name" {
  value = module.gke_cluster.name
}

output "network_policy_enabled" {
  value = module.gke_cluster.network_policy_enabled
}

output "region" {
  value = module.gke_cluster.region
}

output "release_channel" {
  value = module.gke_cluster.release_channel
}

output "service_account" {
  value = module.gke_cluster.service_account
}

output "type" {
  value = module.gke_cluster.type
}

output "zones" {
  value = module.gke_cluster.zones
}
