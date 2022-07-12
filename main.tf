module "resource_group" {
  source = "./modules/resource_group"

  rgname   = var.rgname
  location = var.location
}

module "adb_vnet" {
  source = "./modules/vnet"

  vnet               = var.adb_vnet
  vnet_address_space = var.adb_vnet_address_space
  location           = var.location
  rgname             = var.rgname
}

module "adb_private_subnet" {
  source = "./modules/subnet"

  subnet               = var.adb_private_subnet
  subnet_address_space = var.adb_private_subnet_address_space
  location             = var.location
  rgname               = var.rgname
  vnet                 = var.adb_vnet

  delegation_name = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"

}

module "adb_public_subnet" {
  source = "./modules/subnet"

  subnet               = var.adb_public_subnet
  subnet_address_space = var.adb_public_subnet_address_space
  location             = var.location
  rgname               = var.rgname
  vnet                 = var.adb_vnet
  delegation_name      = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"


}

module "adb_nsg" {
  source = "./modules/nsg"

  nsg      = var.adb_nsg
  location = var.location
  rgname   = var.rgname
}

module "adb_private_subnet_nsg_association" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg.nsg_id
  subnet_id = module.adb_private_subnet.subnet_id

}

module "adb_public_subnet_nsg_association" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg.nsg_id
  subnet_id = module.adb_public_subnet.subnet_id

}

module "dp_datastore" {
  source = "./modules/storage"

  storage_account_name = var.dp_datastore
  location             = var.location
  rgname               = var.rgname
}

module "adb_dataproduct_ws" {
  source = "./modules/adb/ws"

  adb_ws                            = var.adb_ws
  rgname                            = var.rgname
  location                          = var.location
  public_subnet_name                = var.adb_public_subnet
  private_subnet_name               = var.adb_private_subnet
  vnet_id                           = module.adb_vnet.vnet_id
  nsg_public_subnet_association_id  = module.adb_public_subnet_nsg_association.nsg_association_id
  nsg_private_subnet_association_id = module.adb_private_subnet_nsg_association.nsg_association_id
  storage_account_name              = substr(replace(join("", [var.dp_datastore, var.adb_ws]), "-", ""), 1, 24)

}


module "data-product-kv" {
  source = "./modules/azkv"

  kvname    = var.kvname
  rgname    = var.rgname
  location  = var.location
  tenant_id = var.az-tenant-id
}

module "adb_dataproduct_ws_global_init_sh" {
  source           = "./modules/adb/global_init"
  script_path      = var.adb_global_init_path
  global_init_name = "global_init"

}

module "adb_ws_conf" {
  source = "./modules/adb/ws_conf"
  env    = "DEV"
}
