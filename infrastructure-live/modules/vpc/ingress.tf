resource "google_compute_address" "ingress" {
  name    = format("%s-%s-ingress-ip", var.cluster_name, var.env)
  project = var.project_id
  region  = var.region
}

# TODO: Move to cluster module
# module "nginx-controller" {
#   count = var.nginx ? 1 : 0
#   source = "terraform-iaac/nginx-controller/helm"

#   ip_address = google_compute_address.ingress.address

# }


# TODO: Move to ?
# resource "kubernetes_ingress_v1" "this" {
#   count = var.argocd_ingress ? 1 : 0
#   metadata {
#     name      = "argocd-server-http-ingress"
#     namespace = "argocd"
#     annotations = {
#       "kubernetes.io/ingress.class": "nginx"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
#       "ingress.kubernetes.io/ssl-redirect": "true"
#       "nginx.ingress.kubernetes.io/backend-protocol": "HTTPS"
#     }
#   }

#   spec {
#     rule {

#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = var.argo_cd_service_name
#               port {
#                 name = "http"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
