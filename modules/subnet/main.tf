resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = var.rgname
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet_address_space

    dynamic "delegation" {
          for_each = each.value.service_delegation == "true" ? [1] : []
            name = var.delegation_name
            service_delegation {
            name    = var.service_delegation_name
            actions = var.actions
            }        
        }
    
    
}