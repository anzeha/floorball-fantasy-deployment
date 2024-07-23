resource "google_compute_address" "ingress" {
  name    = format("%s-%s-ingress-ip", var.cluster_name, var.env)
  project = var.project_id
  region  = var.region
}


