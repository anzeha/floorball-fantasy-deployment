terraform{
    source = "../../../infrastructure-modules/kubernetes-addons"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

include "env" {
    path           = find_in_parent_folders("env.hcl")
    expose         = true
    merge_strategy = "no_merge"
}

dependency "eks_cluster" {
    config_path = "../cluster"
     mock_outputs = {
       cluster_ca_certificate = "sample-ceritifcate"
       host = "sample-host"
       token = "token"
     }
}

generate "kubernetes_provider" {
  path = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "kubernetes" {
  cluster_ca_certificate = "${dependency.eks_cluster.outputs.cluster_ca_certificate}"
  host                   = "${dependency.eks_cluster.outputs.host}"
  token                  = "${dependency.eks_cluster.outputs.token}"
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode("${dependency.eks_cluster.outputs.cluster_ca_certificate}")
    host                   = "${dependency.eks_cluster.outputs.host}"
    token                  = "${dependency.eks_cluster.outputs.token}"
  }
}
EOF
}

inputs = {
    env            = include.env.locals.env
    project_id     = include.root.locals.config_vars.locals.project_id
}