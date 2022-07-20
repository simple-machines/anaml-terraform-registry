variable "source_id" {
  type        = number
  description = "The ID of the Anaml source to run retrieve table datas from."
}

variable "cluster_id" {
  type        = number
  description = "The ID of the Anaml cluster to run feature stores and previews on."
}

variable "destination_id" {
  type        = number
  description = "The ID of the Anaml destination to write stores to."
}

variable "online_feature_store_id" {
  type        = number
  description = "The ID of the Anaml Online Feature Store destination to write to."
}

variable "source_type" {
  type        = string
  description = "The type of the source: local|gcs"
}

variable "destination_type" {
  type        = string
  description = "The type of the destination: local|gcs"
}

variable "caching_prefix_url" {
  type        = string
  description = "Destination for caching results. e.g gs://anaml-dev-warehouse/vapour-cache"
}

output "customer_entity_id" {
  value = anaml_entity.customer.id
}

output "plan_entity_id" {
  value = anaml_entity.phone_plan.id
}
