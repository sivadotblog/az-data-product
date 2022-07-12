

module "data-product-retail" {
  source         = "./modules/adb/iam"
  group_name     = "data-product-retail-manager"
  application_id = "2fbbfd39-22ed-439c-bf79-d6a92318ce35"

}
