terraform {
  required_providers {

    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "databricks_group" "this" {
  display_name               = var.group_name
  allow_cluster_create       = true
  allow_instance_pool_create = true
}

resource "databricks_service_principal" "sp" {
  application_id = var.application_id
  display_name   = "Project service principal"

  depends_on = [
    databricks_group.this
  ]
}

resource "databricks_group_member" "this" {
  group_id  = databricks_group.this.id
  member_id = databricks_service_principal.sp.id
  depends_on = [
    databricks_group.this,
    databricks_service_principal.sp
  ]
}
