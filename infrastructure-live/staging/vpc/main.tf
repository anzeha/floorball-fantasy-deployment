provider "google" {
  project = "mythic-cocoa-429511-s9"
  region  = "europe-west4-a"
}

module vpc{
    source = "../../modules/vpc"

    env = "dev"
    project_id = "mythic-cocoa-429511-s9"
    argocd_ingress = false
}