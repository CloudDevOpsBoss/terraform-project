locals{
    project ="demo"
    environment = "dev"
    location = "East US "
    prefix = "${local.project}-${local.environment}"
    resource_group_name = "${local.prefix}-rg3"  #----shopping-dev-rg

    common_tags = {
        project     = local.project
        environment = local.environment
        managed_by  = "terraform"
    }

}