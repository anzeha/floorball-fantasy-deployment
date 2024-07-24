provider "google" {
  project = var.project_id
  region  = "europe-west4-a"
}

module "cluster" {
  source = "../../modules/cluster"

  project_id = var.project_id
  env        = "staging"
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
    host                   = module.cluster.host
    token                  = module.cluster.token
  }
}

