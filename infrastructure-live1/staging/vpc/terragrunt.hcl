terraform{
    source = "../../../infrastructure-live/modules/vpc"
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
}