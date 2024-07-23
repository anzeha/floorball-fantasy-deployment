variable "project_id" {
  type = string
}
variable "network" {
  type    = string
  default = "gke-network"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cluster_name" {
  type    = string
  default = "gke-test-1"
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "subnetwork" {
  type    = string
  default = "gke-subnet"
}
variable "ip_range_pods_name" {
  type    = string
  default = "ip-range-pods"
}
variable "ip_range_services_name" {
  type    = string
  default = "ip-range-services"
}
variable "github_token" {
  type = string
}
variable "argo_admin_password" {
  type    = string
  default = "admin"
}