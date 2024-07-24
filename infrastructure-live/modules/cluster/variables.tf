variable "project_id" {
  type = string
}
variable "env" {
  type    = string
}

variable "cluster_name" {
  type    = string
  default = "gke-test-1"
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
# variable "argo_cd_namespace"{
#   type = string
#   default = "argocd"
# }
# variable "argo_cd_service_name"{
#   type = string
#   default = "argocd-server"
# }
variable "deploy_nginx" {
  type = bool
  default = true
}
variable "network" {
  type    = string
  default = "gke-network"
}

variable "subnetwork" {
  type    = string
  default = "gke-subnet"
}