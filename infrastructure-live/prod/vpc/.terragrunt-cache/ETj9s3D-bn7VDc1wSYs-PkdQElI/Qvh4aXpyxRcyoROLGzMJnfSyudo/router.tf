resource "google_compute_router" "this" {
  name       = format("%s-%s-cloud-router", var.cluster_name, var.env)
  project    = var.project_id
  region     = var.region
  network    = module.vpc.network_name
  depends_on = [module.vpc]
}