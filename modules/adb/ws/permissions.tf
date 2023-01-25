terraform {
  required_providers {

    databricks = {
      source = "databricks/databricks"
    }
  }
}


data "databricks_group" "admins" {
  display_name = "admins"
}


resource "databricks_service_principal" "sp" {
  application_id = "2fbbfd39-22ed-439c-bf79-d6a92318ce35"
}

resource "databricks_group_member" "i-am-admin" {
  group_id  = data.databricks_group.admins.id
  member_id = databricks_service_principal.sp.id
}
