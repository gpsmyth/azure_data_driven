# ##############################################
# Resource Group Creation
##############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}

# ##############################################
# # VNet Creation
# ##############################################
module "vnet_creation" {
  source = "./modules/network"

  vnets               = local.vnets
  common_tags         = local.common_tags
  region              = local.region
  resource_group_name = azurerm_resource_group.rg.name
}
