terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "kubernetes" {
  config_path = kind_cluster.kind_cluster_dev.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.kind_cluster_dev.kubeconfig_path
  }
}