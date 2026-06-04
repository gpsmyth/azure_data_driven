# ##############################################
# Terraform root Versions
# ##############################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.14.5"

  # Uncomment when Azure subscription is available
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "tfstate-azure-data-driven"        # must be globally unique
  #   container_name       = "tfstate"
  #   key                  = "cloud-networks/australiaeast/terraform.tfstate"
  # }
}
