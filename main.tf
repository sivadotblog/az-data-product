module "resource_group" {
  source    = "./modules/resource_group"

  rgname    = var.rgname
  location  = var.location
}

module "adb_vnet" {
  source    = "./modules/vnet"

  vnet                = var.adb_vnet
  vnet_address_space  = var.adb_vnet_address_space
  location            = var.location
  rgname = var.rgname
}

module "adb_private_subnet" {
  source    = "./modules/subnet"

  subnet                = var.adb_private_subnet
  subnet_address_space  = var.adb_private_subnet_address_space
  location              = var.location
  rgname = var.rgname
  vnet = var.adb_vnet
}

module "adb_public_subnet" {
  source    = "./modules/subnet"

  subnet                  = var.adb_public_subnet
  subnet_address_space    = var.adb_public_subnet_address_space
  location                = var.location
  rgname                  = var.rgname
  vnet = var.adb_vnet
}