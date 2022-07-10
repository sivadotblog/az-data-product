resource "databricks_global_init_sh" "global_init" {
  source = var.script_path
  name   = var.global_init_name
}