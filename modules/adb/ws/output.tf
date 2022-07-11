output "workspace_url" {
    value = "https://${azurerm_databricks_workspace.adb.workspace_url}/" 
}



output "managed_resource_group_name" {
    value = azurerm_databricks_workspace.adb.managed_resource_group_name
}


output "id" {
    value = azurerm_databricks_workspace.adb.id
}