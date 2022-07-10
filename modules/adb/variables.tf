variable "rgname" {
    type = string
    description = "Name of resource group"
}

variable "location" {
    type = string
    description = "Azure location of resource group"
}

variable "adb_ws" {
    type = string
    description = "Name of ADB workspace"
}

variable "public_subnet_name" {
    type = string

}
variable "private_subnet_name" {
    type = string

}
variable "vnet_id" {
    type = string

}

variable "nsg_private_subnet_association_id" {
    type = string

}
variable "nsg_public_subnet_association_id" {
    type = string

}

variable "storage_account_name" {
    type = string

}

