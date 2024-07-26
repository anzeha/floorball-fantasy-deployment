terraform{
    source = "../../../infrastructure-modules/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

include "config" {
  path           = find_in_parent_folders("config.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
 env            = include.env.locals.env
  project_id     = include.config.locals.project_id
}