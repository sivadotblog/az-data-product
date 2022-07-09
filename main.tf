module "resource_group" {
  source    = "./modules/resource_group"

  rgname    = var.rgname
  location  = var.location
}