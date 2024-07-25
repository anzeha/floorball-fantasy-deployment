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
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "google" {
  region  = "${local.config_vars.locals.region}"
  project = "${local.config_vars.locals.project_id}"
}
EOF
}