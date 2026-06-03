# ##############################################
# Log Analytics workspace for diagnostics
# ##############################################
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.resource_group_name}-law"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.common_tags
}

# VNets
resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.value.name
  address_space       = [each.value.cidr_block]
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.network_tags
}

# Flatten subnets config
locals {
  subnets = merge([
    for vnet_key, vnet in var.vnets : {
      for subnet_key, subnet in vnet.subnets :
      "${vnet_key}-${subnet_key}" => {
        vnet_key   = vnet_key
        name       = subnet.name
        cidr_block = subnet.cidr_block
        nsg        = try(subnet.nsg, null)
        bastion    = try(subnet.bastion, false)
      }
    }
  ]...)
}

# NSGs (only where nsg != null)
resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for k, s in local.subnets : k => s
    if s.nsg != null
  }

  name                = each.value.nsg.name
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.network_tags
}

# Subnets
resource "azurerm_subnet" "subnet" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_key].name
  address_prefixes     = [each.value.cidr_block]
}

# NSG associations
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  for_each = {
    for k, s in local.subnets : k => s
    if s.nsg != null
  }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Bastion public IPs (for subnets marked bastion = true)
resource "azurerm_public_ip" "bastion_pip" {
  for_each = {
    for k, s in local.subnets : k => s
    if s.bastion == true
  }

  name                = "pip-${each.value.name}"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.security_tags
}

# Bastion hosts
resource "azurerm_bastion_host" "bastion" {
  for_each = {
    for k, s in local.subnets : k => s
    if s.bastion == true
  }

  name                = "bastion-${each.value.name}"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.subnet[each.key].id
    public_ip_address_id = azurerm_public_ip.bastion_pip[each.key].id
  }

  tags = var.security_tags
}

# Diagnostics for Bastion
resource "azurerm_monitor_diagnostic_setting" "bastion_diag" {
  for_each = azurerm_bastion_host.bastion

  name                       = "diag-${each.value.name}"
  target_resource_id         = each.value.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "BastionAuditLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}