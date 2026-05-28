# ##############################################
# Outputs
# ##############################################
output "vnet_ids" {
  value = module.vnet_creation.vnet_ids
}

output "subnet_ids" {
  value = module.vnet_creation.subnet_ids
}

output "bastion_ids" {
  value = module.vnet_creation.bastion_ids
}
