remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

locals{
  config_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/config.hcl")
  secret_vars = jsondecode(read_tfvars_file("${get_parent_terragrunt_dir()}/secrets.tfvars"))

  # Extract the variables we need for easy access
  region = local.config_vars.locals.region
  project_id   = local.config_vars.locals.project_id
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "google" {
  region  = "${local.region}"
  project = "${local.project_id}"
}
data "google_client_config" "default" {}
EOF
}