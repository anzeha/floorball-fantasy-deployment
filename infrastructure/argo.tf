resource "htpasswd_password" "hash" {
  password = var.argo_admin_password
}


resource "helm_release" "argocd" {
  depends_on = [ htpasswd_password.hash]
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  create_namespace = true
  namespace = "argocd"

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = htpasswd_password.hash.bcrypt
  }
}

#TODO update te newer version
resource "helm_release" "argo_apps" {
  depends_on = [ htpasswd_password.hash, helm_release.argocd ]
  name = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  create_namespace = true
  namespace = "argocd"
  version    = "0.0.8"

  values = [
    "${file("./values/argo-apps.values.yml")}"
  ]
}

resource "kubernetes_secret_v1" "git_creds" {
  depends_on = [ helm_release.argo_apps ]
  metadata {
    name = "repo-deploy-key"
    namespace = "argocd"
  }

  data = {
    username = "anzeha"
    password = var.github_token
  }
  type = "Opaque"
}

resource "helm_release" "argo_image_updater" {
  name = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  create_namespace = true
  namespace = "argocd"

  depends_on = [ helm_release.argo_apps ]

  values = [
    "${file("./values/argo-image-updater.values.yml")}"
  ]
}