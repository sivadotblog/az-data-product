variable "rgname" {
    type = string
    description = "Name of resource group"
}

variable "location" {
    type = string
    description = "Azure location of resource group"
}

variable "subnet" {
    type = string
}

variable "subnet_address_space" {
    type = list(string)
}

variable "vnet" {
    type = string
}