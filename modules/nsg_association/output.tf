output "nsg_association_id" {
  value = azurerm_subnet_network_security_group_association.subnet_nsg_association.id
}