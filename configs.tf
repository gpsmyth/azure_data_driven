locals {
  region = var.region

  vnets = {
    hub = {
      name       = "hub-vnet"
      cidr_block = "10.0.0.0/20"

      subnets = {
        vm = {
          name       = "vm-subnet"
          cidr_block = "10.0.1.0/24"
          bastion    = false # consistent schema
          nsg = {
            name = "vm-subnet-nsg"
          }
        }
        bastion = {
          name       = "AzureBastionSubnet"
          cidr_block = "10.0.2.0/27"
          bastion    = true
          nsg        = null # consistent schema
        }
      }
    }

    spoke1 = {
      name       = "spoke1-vnet"
      cidr_block = "10.0.16.0/20"

      subnets = {
        app = {
          name       = "app-subnet"
          cidr_block = "10.0.17.0/24"
          bastion    = false
          nsg = {
            name = "app-subnet-nsg"
          }
        }
      }
    }
  }

  common_tags = {
    region      = var.region
    owner       = "gerry"
    Environment = "Dev"      # infracost policy checks exact key
    Service     = "networks" # infracost policy checks exact key
  }

  network_tags = merge(local.common_tags, {
    team = "Networks Team"
  })

  security_tags = merge(local.common_tags, {
    team = "Security Team"
  })
}
