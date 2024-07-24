provider "google" {
  project = var.project_id
  region  = "europe-west4-a"
}

module "vpc" {
  source = "../../modules/vpc"

  env            = "staging"
  project_id     = var.project_id
  argocd_ingress = false
}