module "resource_group" {
  source    = "./modules/resource_group"

  rgname    = var.rgname
  location  = var.location
}

module "vnet" {
  source    = "./modules/networking"

  name                = var.adb_vnet
  address_space       = var.adb_vnet_address_space
  location            = var.location
  resource_group_name = var.rgname
}