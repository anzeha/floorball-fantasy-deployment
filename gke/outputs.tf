output "kubernetes_cluster_name" {
  value = module.gke.name
}

output "region" {
  value = module.gke.region
}