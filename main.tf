locals {
  ws1 = {
    rgname                           = "data-product"
    location                         = "eastus"
    adb_vnet                         = "adb-vnet"
    adb_vnet_address_space           = ["10.0.0.0/24"]
    adb_private_subnet               = "adb-private-subnet"
    adb_public_subnet                = "adb-public-subnet"
    adb_private_subnet_address_space = ["10.0.0.0/26"]
    adb_public_subnet_address_space  = ["10.0.0.64/26"]
    adb_nsg                          = "adb-nsg"
    adb_ws                           = "adb-dataproduct-ws"
    dp_datastore                     = "srdpdatastore"
    adb_global_init_path             = "./global_init/global_initv2.sh"
    kvname                           = "data-product-kv"
  }
}

module "resource_group" {
  source = "./modules/resource_group"

  rgname   = local.ws1.rgname
  location = local.ws1.location
}

module "adb_vnet" {
  source = "./modules/vnet"

  vnet               = local.ws1.adb_vnet
  vnet_address_space = local.ws1.adb_vnet_address_space
  location           = local.ws1.location
  rgname             = local.ws1.rgname
  depends_on = [
    module.resource_group
  ]
}

module "adb_private_subnet" {
  source = "./modules/subnet"

  subnet               = local.ws1.adb_private_subnet
  subnet_address_space = local.ws1.adb_private_subnet_address_space
  location             = local.ws1.location
  rgname               = local.ws1.rgname
  vnet                 = local.ws1.adb_vnet

  delegation_name = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"

  depends_on = [
    module.resource_group,
    module.adb_vnet

  ]
}

module "adb_public_subnet" {
  source = "./modules/subnet"

  subnet               = local.ws1.adb_public_subnet
  subnet_address_space = local.ws1.adb_public_subnet_address_space
  location             = local.ws1.location
  rgname               = local.ws1.rgname
  vnet                 = local.ws1.adb_vnet
  delegation_name      = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"

  depends_on = [
    module.resource_group,
    module.adb_vnet
  ]
}

module "adb_nsg" {
  source = "./modules/nsg"

  nsg      = local.ws1.adb_nsg
  location = local.ws1.location
  rgname   = local.ws1.rgname
  depends_on = [
    module.resource_group
  ]
}

module "adb_private_subnet_nsg_association" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg.nsg_id
  subnet_id = module.adb_private_subnet.subnet_id
  depends_on = [
    module.adb_private_subnet
  ]

}

module "adb_public_subnet_nsg_association" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg.nsg_id
  subnet_id = module.adb_public_subnet.subnet_id
  depends_on = [
    module.adb_public_subnet
  ]

}

module "dp_datastore" {
  source = "./modules/storage"

  storage_account_name = local.ws1.dp_datastore
  location             = local.ws1.location
  rgname               = local.ws1.rgname
  depends_on = [
    module.resource_group,
  ]
}

module "adb_dataproduct_ws" {
  source = "./modules/adb/ws"

  adb_ws                            = local.ws1.adb_ws
  rgname                            = local.ws1.rgname
  location                          = local.ws1.location
  public_subnet_name                = local.ws1.adb_public_subnet
  private_subnet_name               = local.ws1.adb_private_subnet
  vnet_id                           = module.adb_vnet.vnet_id
  nsg_public_subnet_association_id  = module.adb_public_subnet_nsg_association.nsg_association_id
  nsg_private_subnet_association_id = module.adb_private_subnet_nsg_association.nsg_association_id
  storage_account_name              = substr(replace(join("", [local.ws1.dp_datastore, local.ws1.adb_ws]), "-", ""), 1, 24)
  depends_on = [
    module.adb_private_subnet_nsg_association,
    module.adb_public_subnet_nsg_association,
    module.dp_datastore,

  ]
}


/*
module "adb_dataproduct_ws_global_init_sh" {
  source           = "./modules/adb/global_init"
  script_path      = local.ws1.adb_global_init_path
  global_init_name = "global_init"

}

module "adb_ws_conf" {
  source = "./modules/adb/ws_conf"
  env    = "DEV"
}*/
