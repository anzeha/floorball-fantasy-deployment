resource "htpasswd_password" "hash" {
  password = var.argo_admin_password
}


resource "helm_release" "argocd" {
  depends_on       = [htpasswd_password.hash]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
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

#TODO update te newer version
resource "helm_release" "argo_apps" {
  count = var.argo_apps ? 1: 0
  depends_on       = [htpasswd_password.hash, helm_release.argocd]
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  create_namespace = true
  namespace        = "argocd"
  version          = "0.0.8"

  values = [
    "${file("./values/argo-apps.values.yml")}"
  ]
}

resource "kubernetes_secret_v1" "git_creds" {
  count = var.argo_image_updater ? 1: 0
  depends_on = [helm_release.argo_apps]
  metadata {
    name      = "repo-deploy-key"
    namespace = "argocd"
  }

  data = {
    username = "anzeha"
    password = var.github_username
  }
  type = "Opaque"
}

resource "helm_release" "argo_image_updater" {
  count = var.argo_image_updater ? 1: 0
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  create_namespace = true
  namespace        = "argocd"

  depends_on = [helm_release.argo_apps]

  values = [
    "${file("./values/argo-image-updater.values.yml")}"
  ]
}

data "kubernetes_service" "argocd-server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

