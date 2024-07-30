terraform{
    source = "../../../infrastructure-modules/cluster"
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

inputs = {
    env            = include.env.locals.env
    project_id     = include.root.locals.config_vars.locals.project_id

    network = dependency.vpc.outputs.vpc_network_name
    subnetwork = dependency.vpc.outputs.vpc_subnetwork_name
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network = "example-network"
    subnetwork = "example-subnetwork"
  }
}