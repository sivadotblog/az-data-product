variable "az-tenant-id" {
  type = string
}

variable "az-subscription-id" {
  type = string
}

variable "az-client-id" {
  type = string
}

variable "az-client-secret" {
  type = string
}

variable "rgname" {
    type = string
    description = "Name of resource group"
}

variable "location" {
    type = string
    description = "Azure location of resource group"
}

variable "adb_vnet" {
    type = string
}
variable "adb_vnet_address_space" {
    type = list(string)
}

variable "adb_private_subnet" {
    type = string
}

variable "adb_private_subnet_address_space" {
    type = list(string)
}

variable "adb_public_subnet" {
    type = string
}

variable "adb_public_subnet_address_space" {
    type = list(string)
}

variable "adb_nsg" {
    type = string

}

variable "dp_datastore" {
    type = string
}
  

variable "adb_ws" {
    type = string
}

variable "adb_global_init_path" {
    type = string
}
