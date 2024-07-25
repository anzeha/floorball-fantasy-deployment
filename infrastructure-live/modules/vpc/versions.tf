terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    htpasswd = {
      version = "~> 1.2.1"
      source = "loafoe/htpasswd"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
