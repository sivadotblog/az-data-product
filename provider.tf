terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.13.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "1.0.1"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = var.az-subscription-id
  tenant_id         = var.az-tenant-id
  client_id         = var.az-client-id
  client_secret     = var.az-client-secret
}

provider "databricks" {
   features {}
 /* azure_auth = {
    managed_resource_group = module.adb_dataproduct_ws.managed_resource_group_name
    azure_region           = var.location
    workspace_name         = var.adb_ws
    resource_group         = var.rgname
    client_id              = var.az-client-id
    client_secret          = var.az-client-secret
    tenant_id              = var.az-tenant-id
    subscription_id        = var.az-subscription-id
  } */
}

data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest" {}
data "databricks_node_type" "smallest" {
  local_disk = true
}