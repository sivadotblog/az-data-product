terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.13.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.0.1"
    }
  }
  cloud {
    organization = "sivas-tech"

    workspaces {
      name = "az-dbk"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id = var.az-subscription-id
  tenant_id       = var.az-tenant-id
  client_id       = var.az-client-id
  client_secret   = var.az-client-secret
}

data "databricks_current_user" "me" {
  depends_on = [module.adb_dataproduct_ws]
}

provider "databricks" {
  # Configuration options
  host                        = module.adb_dataproduct_ws.workspace_url
  azure_workspace_resource_id = module.adb_dataproduct_ws.id
  azure_client_id             = var.az-client-id
  azure_client_secret         = var.az-client-secret
  azure_tenant_id             = var.az-tenant-id

}

/*
data "databricks_current_user" "me" {
  depends_on = [azurerm_databricks_workspace.adb_dataproduct_ws]
}
data "databricks_spark_version" "latest" {
  depends_on = [azurerm_databricks_workspace.adb_dataproduct_ws]
}
data "databricks_node_type" "smallest" {
  local_disk = true
  depends_on = [azurerm_databricks_workspace.adb_dataproduct_ws]
}
*/




