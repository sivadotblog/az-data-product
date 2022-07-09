resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.rgname
}

