resource "htpasswd_password" "hash" {
  password = var.argo_admin_password
}


resource "helm_release" "argocd" {
  depends_on       = [htpasswd_password.hash]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = var.argocd_namespace
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = htpasswd_password.hash.bcrypt
  }
  set {
    name  = "configs.params.server.insecure"
    value = false
  }

  set {
    name  = "server.ingress.enabled"
    value = true
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
}

resource "kubernetes_namespace_v1" "floorball_fantasy_namespace" {
    count = var.deploy_app ? 1 : 0
    metadata {
      name = "floorball-fantasy"
    }
}


#TODO update te newer version
resource "helm_release" "argo_apps" {
  count = var.argo_apps ? 1: 0
  depends_on       = [htpasswd_password.hash, helm_release.argocd]
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  create_namespace = true
  namespace        = var.argocd_namespace
  version          = "0.0.8"

  values = var.deploy_app ? [
    var.argo_apps_values
  ] : []
}

resource "kubernetes_secret_v1" "git_creds" {
  count = var.argo_image_updater ? 1: 0
  depends_on = [helm_release.argo_apps]
  metadata {
    name      = "repo-deploy-key"
    namespace = var.argocd_namespace
  }

  data = {
    username = "anzeha"
    password = var.github_token
  }
  type = "Opaque"
}

resource "helm_release" "argo_image_updater" {
  count = var.argo_image_updater ? 1: 0
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  create_namespace = true
  namespace        = var.argocd_namespace

  depends_on = [helm_release.argo_apps]

  values = [
    var.argo_image_updater_values
  ]
}

data "kubernetes_service" "argocd-server" {
  metadata {
    name      = "argocd-server"
    namespace = var.argocd_namespace
  }
  depends_on = [helm_release.argocd]
}


resource "kubernetes_ingress_v1" "this" {
  depends_on = [ helm_release.argocd ]
  count = var.setup_argocd_ingress ? 1 : 0
  metadata {
    name      = "argocd-server-http-ingress"
    namespace = var.argocd_namespace
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
