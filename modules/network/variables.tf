variable "vnets" {
  description = "Map of VNet configurations"
  type        = any
}

variable "region" {
  description = "Azure region for all resources"
  type = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}
