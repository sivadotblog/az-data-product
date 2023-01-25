locals {
  ws2 = {
    rgname                           = "data-product-2"
    location                         = "eastus"
    adb_vnet                         = "adb-vnet"
    adb_vnet_address_space           = ["10.0.0.0/24"]
    adb_private_subnet               = "adb-private-subnet"
    adb_public_subnet                = "adb-public-subnet"
    adb_private_subnet_address_space = ["10.0.0.0/26"]
    adb_public_subnet_address_space  = ["10.0.0.64/26"]
    adb_nsg                          = "adb-nsg"
    adb_ws                           = "adb-dataproduct-ws"
    dp_datastore                     = "srdpdatastorews2"
    adb_global_init_path             = "./global_init/global_initv2.sh"
    kvname                           = "data-product-kv"
  }
}

module "resource_group_ws2" {
  source = "./modules/resource_group"

  rgname   = local.ws2.rgname
  location = local.ws2.location
}

module "adb_vnet_ws2" {
  source = "./modules/vnet"

  vnet               = local.ws2.adb_vnet
  vnet_address_space = local.ws2.adb_vnet_address_space
  location           = local.ws2.location
  rgname             = local.ws2.rgname
  depends_on = [
    module.resource_group_ws2
  ]
}

module "adb_private_subnet_ws2" {
  source = "./modules/subnet"

  subnet               = local.ws2.adb_private_subnet
  subnet_address_space = local.ws2.adb_private_subnet_address_space
  location             = local.ws2.location
  rgname               = local.ws2.rgname
  vnet                 = local.ws2.adb_vnet

  delegation_name = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"

  depends_on = [
    module.resource_group_ws2,
    module.adb_vnet_ws2

  ]
}

module "adb_public_subnet_ws2" {
  source = "./modules/subnet"

  subnet               = local.ws2.adb_public_subnet
  subnet_address_space = local.ws2.adb_public_subnet_address_space
  location             = local.ws2.location
  rgname               = local.ws2.rgname
  vnet                 = local.ws2.adb_vnet
  delegation_name      = "adb-databricks-del"
  actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
  service_delegation_name = "Microsoft.Databricks/workspaces"

  depends_on = [
    module.resource_group_ws2,
    module.adb_vnet_ws2
  ]
}

module "adb_nsg_ws2" {
  source = "./modules/nsg"

  nsg      = local.ws2.adb_nsg
  location = local.ws2.location
  rgname   = local.ws2.rgname
  depends_on = [
    module.resource_group_ws2
  ]
}

module "adb_private_subnet_nsg_association_ws2" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg_ws2.nsg_id
  subnet_id = module.adb_private_subnet_ws2.subnet_id
  depends_on = [
    module.adb_private_subnet_ws2
  ]

}

module "adb_public_subnet_nsg_association_ws2" {
  source = "./modules/nsg_association"

  nsg_id    = module.adb_nsg_ws2.nsg_id
  subnet_id = module.adb_public_subnet_ws2.subnet_id
  depends_on = [
    module.adb_public_subnet_ws2
  ]

}

module "dp_datastore_ws2" {
  source = "./modules/storage"

  storage_account_name = local.ws2.dp_datastore
  location             = local.ws2.location
  rgname               = local.ws2.rgname
  depends_on = [
    module.resource_group_ws2,
  ]
}

module "adb_dataproduct_ws2" {
  source = "./modules/adb/ws"

  adb_ws                            = local.ws2.adb_ws
  rgname                            = local.ws2.rgname
  location                          = local.ws2.location
  public_subnet_name                = local.ws2.adb_public_subnet
  private_subnet_name               = local.ws2.adb_private_subnet
  vnet_id                           = module.adb_vnet_ws2.vnet_id
  nsg_public_subnet_association_id  = module.adb_public_subnet_nsg_association_ws2.nsg_association_id
  nsg_private_subnet_association_id = module.adb_private_subnet_nsg_association_ws2.nsg_association_id
  storage_account_name              = substr(replace(join("", [local.ws2.dp_datastore, local.ws2.adb_ws]), "-", ""), 1, 24)
  depends_on = [
    module.adb_private_subnet_nsg_association_ws2,
    module.adb_public_subnet_nsg_association_ws2,
    module.dp_datastore_ws2,

  ]
}


/*
module "adb_dataproduct_ws_global_init_sh" {
  source           = "./modules/adb/global_init"
  script_path      = local.ws2.adb_global_init_path
  global_init_name = "global_init"

}

module "adb_ws_conf" {
  source = "./modules/adb/ws_conf"
  env    = "DEV"
}*/



data "databricks_group" "admins_ws2" {
  provider     = databricks.ws2
  display_name = "admins"
}

resource "databricks_service_principal" "sp_ws2" {
  provider       = databricks.ws2
  application_id = "2fbbfd39-22ed-439c-bf79-d6a92318ce35"
}

resource "databricks_group_member" "i-am-admin_ws2" {
  provider  = databricks.ws2
  group_id  = data.databricks_group.admins_ws2.id
  member_id = databricks_service_principal.sp_ws2.id
}


resource "databricks_user" "me_ws2" {
  provider  = databricks.ws2
  user_name = "sivanandha@live.com"
}

resource "databricks_group_member" "my_member_a_ws2" {
  provider  = databricks.ws2
  group_id  = data.databricks_group.admins_ws2.id
  member_id = databricks_user.me_ws2.id
}


data "databricks_group" "admins" {

  display_name = "admins"
}
resource "databricks_user" "me" {

  user_name = "sivanandha@live.com"
}

resource "databricks_group_member" "my_member_a" {

  group_id  = data.databricks_group.admins.id
  member_id = databricks_user.me.id
}
