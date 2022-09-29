/**
 * # gcp-gke-cluster/
 *
 * Creates a private GKE cluster specifically for Anaml. The GKE cluster contains node pool for the application services and node pool specifically for Apache Spark workers.
 *
 * This module mostly wraps the official Google Terraform GKE [private-cluster](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/21.1.0/submodules/private-cluster) module.
 */
terraform {
  required_version = ">= 1.1"
}


resource "random_id" "name_suffix" {
  byte_length = 8
}


# TODO: To ensure that the service account used here is named consistently, we should
# look to use the `service_account` attribute, the next time this cluster is rebuilt.
module "gke_cluster" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                = "21.2.0"
  grant_registry_access  = true
  project_id             = var.gcp_project_id
  name                   = "${var.name_prefix}-${random_id.name_suffix.hex}"
  region                 = var.gcp_region
  regional               = var.regional
  zones                  = var.gcp_zones
  create_service_account = false
  service_account        = var.service_account
  # Specify the version of Kubernetes, so that Kubernetes isn't automatically
  # upgraded at inconvenient times. Upgrading Kubernetes takes 30+ minutes, and
  # will prevent further changes from being made to the cluster until the
  # upgrade is complete.
  kubernetes_version        = var.kubernetes_version
  network                   = var.network
  subnetwork                = var.subnetwork
  ip_range_pods             = var.ip_range_pods
  default_max_pods_per_node = 60 # TODO check subnet sizes
  ip_range_services         = var.ip_range_services
  enable_private_endpoint   = false
  enable_private_nodes      = true

  master_ipv4_cidr_block   = var.master_ipv4_cidr_block
  remove_default_node_pool = true

  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time


  release_channel = "REGULAR"

  node_pools = [
    {
      # Anaml-server should be run with multiple replicas in production for
      # redundancy, and to allow rolling upgrades.
      name               = "anaml-app-pool"
      machine_type       = var.anaml_app_pool_machine_type
      node_locations     = join(",", var.gcp_zones)
      min_count          = var.min_anaml_app_node_pool_size
      max_count          = var.max_anaml_app_node_pool_size
      initial_node_count = var.min_anaml_app_node_pool_size
      disk_size_gb       = 100
      auto_upgrade       = true
    },

    {
      name               = "anaml-spark-pool"
      machine_type       = var.anaml_spark_pool_machine_type
      preemptible        = true
      node_locations     = join(",", var.gcp_zones)
      autoscaling        = true
      min_count          = var.min_anaml_spark_node_pool_size
      max_count          = var.max_anaml_spark_node_pool_size
      initial_node_count = 0
      disk_size_gb       = 200
      local_ssd_count    = 0
      auto_upgrade       = true
    }
  ]
  node_pools_taints = {
    anaml-spark-pool = [
      {
        key    = "anaml-spark-pool"
        value  = "true"
        effect = "NO_SCHEDULE"
      },
    ],
  }
}

# Allow cluster to scale down to a single node
resource "kubernetes_pod_disruption_budget" "kube_dns" {
  count = var.max_anaml_app_node_pool_size <= 2 ? 1 : 0

  metadata {
    name      = "kube-dns-pdb"
    namespace = "kube-system"
  }

  spec {
    max_unavailable = "1"
    selector {
      match_labels = {
        k8s-app = "kube-dns"
      }
    }
  }
}


module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.gcp_project_id
  cluster_name = module.gke_cluster.name
  location     = module.gke_cluster.region
}
