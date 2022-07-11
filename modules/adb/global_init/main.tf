terraform {
  required_providers {

    databricks = {
      source = "databricks/databricks"
      version = "1.0.1"
    }
  }
}

resource "databricks_global_init_script" "global_init" {
  


  source = var.script_path
  name   = var.global_init_name

}