provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
    host                   = module.cluster.host
    token                  = module.cluster.token
  }
}

module "argo" {
  source = "../../modules/argo"

  github_token    = var.github_token
  github_username = var.github_username
  env             = "staging"

  argo_apps_values          = file("./values/argo-apps.values.yml")
  argo_image_updater_values = file("./values/argo-image-updater.values.yml")

}