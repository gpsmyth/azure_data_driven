## Learnings on Azure


### Root structure

```text
.
├── versions.tf
├── providers.tf
├── configs.tf
├── main.tf
├── outputs.tf
└── modules
    └── network
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Using a data driven approach to build terraform

- build a `configs.tf` for australiaeast
- use `locals` to define all VNet + subnet structure
- loop through those locals to create resources/modules

`configs.tf` gives you:
- One place to define all VNet + subnet structure
- No hardcoded values in modules
- Easy reuse across environments
- `hub` and `spoke1` are map keys — they act as unique identifiers within the `vnets` map, 
  - Think of it like a dictionary where each key gives you a named VNet definition.

### notes on configs.tf

`name` is not just a map key; it is the actual Azure subnet name value.
The map key (`bastion`) is only a local identifier in Terraform, not the Azure subnet name.
For Azure Bastion, the subnet must be named exactly `AzureBastionSubnet`

### Storage Account

- Referencing [terraform storage account docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

### RBAC for a Storage Account

- Referencing [terrafrom RBAC role assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)

### Log Analytics

- Referencing [terraform diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
