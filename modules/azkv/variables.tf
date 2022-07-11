variable "tenant_id" {
    type = string
    description = "Tenant ID"
}

variable "rgname" {
    type = string
    description = "Name of resource group"
}

variable "location" {
    type = string
    description = "Azure location of resource group"
}

variable "kvname" {
    type = string
    description = "Name of key vault"
}