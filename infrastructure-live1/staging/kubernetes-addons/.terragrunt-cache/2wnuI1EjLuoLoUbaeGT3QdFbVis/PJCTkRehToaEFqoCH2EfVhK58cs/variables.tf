variable "project_id" {
  type = string
}
variable "env" {
  type    = string
}
variable "deploy_nginx" {
  type = bool
  default = true
}
variable "cluster_name" {
  type    = string
  default = "gke-test-1"
}

variable "region" {
  type    = string
  default = "europe-west4"
}