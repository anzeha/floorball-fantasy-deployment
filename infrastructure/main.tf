# Create a dev cluster
resource "kind_cluster" "kind_cluster_dev" {
  name           = "dev-cluster"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
    }
    node {
      role = "worker"
    }
  }
}

resource "null_resource" "apply_yaml" {
  depends_on = [kind_cluster.kind_cluster_dev]
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
      kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
    EOT
  }
}

resource "htpasswd_password" "hash" {
  password = var.argo_admin_password
}

resource "helm_release" "argo" {
  depends_on = [ htpasswd_password.hash ]
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  create_namespace = true
  namespace = "argocd"

  # Does not work, rather use kubernetes manifest resource
  # values = [
  #   "${file("./values/argo-cd.yml")}"
  # ]
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = htpasswd_password.hash.bcrypt
  }
}

#TODO update te newer version
resource "helm_release" "argo_apps" {
  depends_on = [ htpasswd_password.hash, helm_release.argo ]
  name = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  create_namespace = true
  namespace = "argocd"
  version    = "0.0.8"

  values = [
    "${file("./values/values.yml")}"
  ]
}

resource "helm_release" "argo_image_updater" {
  name = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  create_namespace = true
  namespace = "argocd"

  depends_on = [ helm_release.argo_apps ]

  values = [
    "${file("./values/image-updater-values.yml")}"
  ]
}

resource "helm_release" "atlas_operator" {
  name       = "atlas-operator"
  repository = "oci://ghcr.io/ariga/charts"
  chart      = "atlas-operator"
  namespace  = "atlas-operator"
  create_namespace = true

  # Add any additional configuration or values here if needed
}

resource "kubernetes_namespace_v1" "floorball_fantasy_namespace" {
    metadata {
      name = "floorball-fantasy"
    }
}
