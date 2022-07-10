resource "azurerm_databricks_workspace" "adb" {
  name                = var.adb_ws
  resource_group_name = var.rgname
  location            = var.location
  sku                 = "standard"
  public_network_access_enabled = false

  custom_parameters {
    no_public_ip        = "true"
    public_subnet_name  = var.public_subnet_name
    private_subnet_name = var.private_subnet_name
    virtual_network_id   = var.vnet_id
    public_subnet_network_security_group_association_id   = var.nsg_public_subnet_association_id
    private_subnet_network_security_group_association_id  = var.nsg_private_subnet_association_id
    storage_account_name  = var.storage_account_name
  }

}