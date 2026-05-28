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
          nsg = {
            name = "app-subnet-nsg"
          }
        }
      }
    }
  }

  common_tags = {
    environment = "dev"
    region      = var.region
    owner       = "gerry"
  }
}
