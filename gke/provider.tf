provider "google" {
  project = "mythic-cocoa-429511-s9"
  region  = "europe-west4-a"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
    null = {
      source = "hashicorp/null"
    }
    htpasswd = {
      version = "~> 1.2.1"
      source  = "loafoe/htpasswd"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
  }
}



provider "htpasswd" {
}