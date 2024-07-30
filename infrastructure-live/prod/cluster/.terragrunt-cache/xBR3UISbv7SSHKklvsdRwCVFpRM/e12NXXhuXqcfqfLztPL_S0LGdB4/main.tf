module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id               = var.project_id
  name                     = "${var.cluster_name}-${var.env}"
  regional                 = false
  zones                    = ["${var.region}-a"]
  region                   = var.region
  network                  = "${var.network}"
  subnetwork               = "${var.subnetwork}"
  ip_range_pods            = var.ip_range_pods_name
  ip_range_services        = var.ip_range_services_name
  enable_private_nodes     = true
  remove_default_node_pool = true
  logging_service          = "none"
  monitoring_service       = "none"

  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = false
  filestore_csi_driver       = false
  dns_cache                  = false
  create_service_account     = true
  deletion_protection        = false

  node_pools = [
    {
      name           = "${var.node_pool_name}-${var.env}"
      machine_type   = var.machine_type
      node_locations = "${var.region}-a"
      disk_size_gb   = 30
      spot           = true
      #   service_account = "gke-terraform@${var.project_id}.iam.gserviceaccount.com"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

   node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

#GKE Auth
module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
  depends_on   = [module.gke.name]
}

# resource "google_compute_address" "ingress" {
#   name    = format("%s-%s-ingress-ip", var.cluster_name, var.env)
#   project = var.project_id
#   region  = var.region
# }


# module "nginx-controller" {
#   count = var.deploy_nginx ? 1 : 0
#   source = "terraform-iaac/nginx-controller/helm"

#   ip_address = google_compute_address.ingress.address

# }


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