########################################
# Resource Groups
########################################

output "network_resource_group" {
  value = azurerm_resource_group.network.name
}

output "infrastructure_resource_group" {
  value = azurerm_resource_group.infrastructure.name
}

########################################
# Networking
########################################

output "vnet_name" {
  value = "${local.prefix}-vnet"
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

########################################
# Active Directory
########################################

output "domain_name" {
  value = "ad.motwane.com"
}

output "domain_controller_name" {
  value = "${local.prefix}-dc-01"
}

output "domain_controller_private_ip" {
  value = module.adds.private_ip_address
}
