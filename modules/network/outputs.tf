# ##############################################
# Module Outputs
# ##############################################
output "vnet_ids" {
  value = {
    for k, v in azurerm_virtual_network.vnet : k => v.id
  }
}

output "subnet_ids" {
  value = {
    for k, s in azurerm_subnet.subnet : k => s.id
  }
}

output "bastion_ids" {
  value = {
    for k, b in azurerm_bastion_host.bastion : k => b.id
  }
}
