module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env}"
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "${var.subnetwork}-${var.env}"
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    "${var.subnetwork}-${var.env}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_cidr_range_pods
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_cidr_range_services
      }
    ]
  }

  routes = [
        {
            name                   = "egress-internet-${var.env}"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
    ]
}
