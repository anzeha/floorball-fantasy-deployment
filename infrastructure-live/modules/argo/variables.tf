variable "env" {
  type = string
  description = "Environment name"
}

variable "argo_admin_password" {
    type = string
    default = "admin"
}

variable "argo_apps" {
  type = bool
  default = true
  description = "Deploy ArgoApps"
}

variable "argo_image_updater" {
  type = bool
  default = true
  description = "Deploy Argo image updater"
}

variable "github_username" {
  type = string
  description = "Github username."
}

variable "github_token" {
  type = string
}

