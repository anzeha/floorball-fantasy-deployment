output "cluster_ca_certificate" {
  value = base64encode(module.gke_auth.cluster_ca_certificate)
  sensitive = true
}

output "host" {
  value = module.gke_auth.host
  sensitive = true
}

output "token" {
  value = module.gke_auth.token
  sensitive = true
}