variable "vnets" {
  description = "Map of VNet configurations"
  type        = any
}

variable "region" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "network_tags" {
  description = "Tags applied to networking resources (VNets, subnets, NSGs)"
  type        = map(string)
  default     = {}
}

variable "security_tags" {
  description = "Tags applied to security resources (Bastion, public IPs, diagnostics)"
  type        = map(string)
  default     = {}
}
