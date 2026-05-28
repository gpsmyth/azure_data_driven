variable "vnets" {
  description = "Map of VNet configurations"
  type        = any
}

variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
