provider "google" {
  project = "mythic-cocoa-429511-s9"
  region  = "europe-west4-a"
}

module "cluster" {
  source = "../../modules/cluster"

  project_id     = "mythic-cocoa-429511-s9"
  argocd_ingress = false
}

provider "kubernetes" {
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
  host                   = module.cluster.host
  token                  = module.cluster.token
}
