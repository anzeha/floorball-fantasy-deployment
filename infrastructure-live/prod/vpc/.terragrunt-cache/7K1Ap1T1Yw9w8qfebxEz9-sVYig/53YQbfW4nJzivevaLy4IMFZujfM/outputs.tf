output "vpc_network_name" {
    value = module.vpc.network_name
}
output "vpc_subnetwork_name" {
  value = module.vpc.subnets_names[0]
}