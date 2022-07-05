provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = module.gke_auth.host
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  token                  = module.gke_auth.token
}
