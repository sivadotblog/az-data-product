terraform {
  required_providers {

    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "databricks_directory" "dir" {
  path = "/Repos/${var.env}"
}

resource "databricks_workspace_conf" "this" {
  custom_config = {
    "enableTokensConfig" : true

  }
}
