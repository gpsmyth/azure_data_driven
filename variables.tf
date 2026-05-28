variable "region" {
  description = "Azure region for all resources"
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-network-storage"
}
