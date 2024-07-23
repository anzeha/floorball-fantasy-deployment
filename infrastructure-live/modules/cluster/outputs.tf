output "cluster_ca_certificate" {
  value = module.gke_auth.cluster_ca_certificate
}

output "host" {
  value = module.gke_auth.host
}

output "token" {
  value = module.gke_auth.token
}