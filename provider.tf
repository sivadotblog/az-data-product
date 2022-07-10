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
  # Configuration options
}