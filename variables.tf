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