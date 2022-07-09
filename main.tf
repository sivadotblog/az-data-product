module "resource_group" {
  source    = "./modules/resource_group"

  rgname    = var.rgname
  location  = var.location
}

module "adb_vnet" {
  source    = "./modules/vnet"

  name                = var.adb_vnet
  address_space       = var.adb_vnet_address_space
  location            = var.location
  resource_group_name = var.rgname
}

module "adb_private_subnet" {
  source    = "./modules/subnet"

  name                = var.adb_private_subnet
  address_space       = var.adb_private_subnet_address_space
  location            = var.location
  resource_group_name = var.rgname
}

module "adb_public_subnet" {
  source    = "./modules/subnet"

  name                = var.adb_public_subnet
  address_space       = var.adb_public_subnet_address_space
  location            = var.location
  resource_group_name = var.rgname
}