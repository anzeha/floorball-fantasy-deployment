variable "project_id" {
  type = string
}
variable "env" {
  type    = string
}

variable "cluster_name" {
  type    = string
  default = "gke-cluster"
}
variable "node_pool_name"{
  type = string
  default = "node-pool"
}
variable "machine_type" {
  type = string
  default = "e2-standard-2"
}

variable "region" {
  type    = string
  default = "europe-west4"
}
variable "ip_range_pods_name" {
  type    = string
  default = "ip-range-pods"
}
variable "ip_range_services_name" {
  type    = string
  default = "ip-range-services"
}
variable "network" {
  type    = string
}

variable "subnetwork" {
  type    = string
}