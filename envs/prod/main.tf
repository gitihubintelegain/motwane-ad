########################################
# Terraform + Backend
########################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateprodstorage1"
    container_name       = "tfstate"
    key                  = "motwane-prod.tfstate"
  }
}

########################################
# Azure Provider
########################################

provider "azurerm" {
  features {}
}

########################################
# Local Values
########################################

locals {

  ########################################
  # Customer + Environment
  ########################################

  client_name = "motwane"
  environment = "prod"

  ########################################
  # Azure Region
  ########################################

  location      = "Central India"
  location_code = "cin"

  ########################################
  # Naming Prefix
  ########################################

  prefix = "${local.client_name}-${local.environment}-${local.location_code}"

  ########################################
  # Common Tags
  ########################################

  tags = {
    client      = local.client_name
    environment = local.environment
    managed_by  = "terraform"
  }
}

########################################
# Resource Groups
########################################

resource "azurerm_resource_group" "network" {
  name     = "${local.prefix}-rg-network"
  location = local.location

  tags = local.tags
}

resource "azurerm_resource_group" "infrastructure" {
  name     = "${local.prefix}-rg-infra"
  location = local.location

  tags = local.tags
}

########################################
# Network Module
########################################

module "network" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//network"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  ########################################
  # VNET
  ########################################

  vnet_name = "${local.prefix}-vnet"

  vnet_cidr = "172.20.0.0/22"

  ########################################
  # Subnets
  ########################################

  subnets = {

    # Future Internet Facing Resources
    "${local.prefix}-snet-public" = "172.20.0.0/24"

    # Application / Internal Servers
    "${local.prefix}-snet-private" = "172.20.1.0/24"

    # Active Directory
    "${local.prefix}-snet-ad" = "172.20.2.0/24"

    # Azure VPN Gateway
    "GatewaySubnet" = "172.20.3.0/26"
  }

  tags = local.tags
}

########################################
# Active Directory Domain Services
########################################

module "adds" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//adds"

  ########################################
  # General
  ########################################

  resource_group_name = azurerm_resource_group.infrastructure.name
  location            = local.location

  ########################################
  # Networking
  ########################################

  subnet_id = module.network.subnet_ids["${local.prefix}-snet-ad"]

  private_ip_address = "172.20.2.4"

  ########################################
  # VM Configuration
  ########################################

  vm_name       = "${local.prefix}-dc-01"
  computer_name = "dc01"

  vm_size = "Standard_D4a_v4"

  ########################################
  # Credentials
  ########################################

  admin_username = var.admin_username
  admin_password = var.admin_password

  ########################################
  # Active Directory
  ########################################

  domain_name        = "motwane.com"
  safe_mode_password = var.admin_password

  ########################################
  # Tags
  ########################################

  tags = local.tags
}

########################################
# Configure VNet DNS
########################################

resource "azurerm_virtual_network_dns_servers" "dns" {

  virtual_network_id = module.network.vnet_id

  dns_servers = [
    module.adds.private_ip_address,
    "8.8.8.8"
  ]
}

########################################
# VPN Gateway Module
########################################

module "vpn_gateway" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//vpngateway"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  gateway_subnet_id = module.network.subnet_ids["GatewaySubnet"]

  public_ip_name   = "${local.prefix}-pip-vpngw"
  vpn_gateway_name = "${local.prefix}-vpngw"

  vpn_sku = "VpnGw1AZ"

  tags = local.tags
}
