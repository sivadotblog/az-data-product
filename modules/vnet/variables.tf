variable "rgname" {
    type = string
    description = "Name of resource group"
}

variable "location" {
    type = string
    description = "Azure location of resource group"
}

variable "vnet" {
    type = string
}
variable "vnet_address_space" {
    type = string
}

