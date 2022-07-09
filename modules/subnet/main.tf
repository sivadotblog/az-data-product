resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = var.rgname
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet_address_space
}