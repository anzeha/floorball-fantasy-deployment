resource "google_compute_address" "ingress" {
  name    = format("%s-%s-ingress-ip", var.cluster_name, var.env)
  project = var.project_id
  region  = var.region
}

module "nginx-controller" {
  source = "terraform-iaac/nginx-controller/helm"

  ip_address = google_compute_address.ingress.address

}


resource "kubernetes_ingress_v1" "argo_ingress" {
  metadata {
    name      = "argocd-server-http-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class": "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
      "ingress.kubernetes.io/ssl-redirect": "true"
      "nginx.ingress.kubernetes.io/backend-protocol": "HTTPS"
    }
  }

  spec {
    rule {

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "argocd-server"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
}
