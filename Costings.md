## Incorporate costing of resources

### Using Infracost

When reading about [pre-commit hook](https://github.com/antonbabenko/pre-commit-terraform), I came across [Infracost][def].

[def]: https://github.com/infracost/infracost

### What Infracost does

It reads your Terraform code and estimates the monthly cloud cost **before anything is deployed**, by checking against the cloud provider's pricing APIs.

```bash
terraform plan / your .tf files
         ↓
infracost breakdown
         ↓
Estimated cost: $47.23/month
  azurerm_virtual_network:     $0.00
  azurerm_bastion_host:        $140.16  ← flags expensive resources
  azurerm_storage_account:     $2.30
```

### Why it's particularly valuable for Azure

Azure Bastion (which I have in my `configs.tf`) is one of the more expensive "invisible" costs — it runs at roughly **$140/month** just for the host, before any data transfer. Infracost would flag that immediately before you deploy.

### Infracost setup

```bash
brew install infracost
infracost auth login    # free account needed for pricing API
```

The following steps are required:

- An organisation is now required to set up
  - Go to [Infracost Dashboard][def2] and create a free organisation.
- Re-authenticate to pick up the org:
  ```bash
  infracost auth login
  ```
- Run Infracost:
  ```bash
  infracost scan
  ```

[def2]: https://dashboard.infracost.io

### Benefits Infracost brought to this project

Initially running Infracost provided the following output locally:

```bash
infracost scan .
```

```text
✔  Scan complete
╭──────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                          │
│   Scan Summary                                                                           │
│                                                                                          │
│   Resources:     14 (3 costed, 11 free)                                                  │
│   Monthly cost:  $142                                                                    │
│                                                                                          │
│   FinOps:        1                                                                       │
│   Tagging:       1 (⚠️ x1)                                                               │
│   Guardrails:    0                                                                       │
│   Budgets:       0                                                                       │
│                                                                                          │
│   ⚠️  = failing policy
```

### Fixes deployed

- New tags for various teams were added that would own the infrastructure
  - For example `network_tags` was added to VNETs and NSGs
  - `security_tags` was added to bastions
- reran `infracost scan .` (Still produce tagging policy error)
  - ran `infracost inspect --failing` which produced (showing anipppet)
  - ```text
    Failing policies  (1 policy · 8 resources)

    🏷️  FinOps tags
      module.vnet_creation.azurerm_log_analytics_workspace.law · modules/network/main.tf:4
      This example Tagging policy shows how you can enforce required FinOps tag keys/values in pull requests.
      This example checks for the tags 'Service' (can have any value) and 'Environment' (must be
      Dev/Stage/Prod) on all taggable resources being changed in the pull request. You can adjust it from
      https://dashboard.infracost.io > Governance > Tagging policies. You have a 14 day trial of this feature
      as it's part of Infracost Cloud.
   ```
  - Added exact `Service` and `Environment` tags into `common_tags`:
    - `Service = "<service-name>"` (any value allowed)
    - `Environment = "Dev" | "Stage" | "Prod"`
- Final output showed
```bash
 infracost scan .
  ✔  Scan complete
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                         │
│   Scan Summary                                                                                          │
│                                                                                                         │
│   Resources:     14 (3 costed, 11 free)                                                                 │
│   Monthly cost:  $142                                                                                   │
│                                                                                                         │
│   FinOps:        1                                                                                      │
│   Tagging:       1                                                                                      │
│   Guardrails:    0                                                                                      │
│   Budgets:       0                                                                                      │
│                                                                                                         │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### Resource costings

- My output is shown as follows:

```bash
infracost inspect --group-by resource
Resource                                                                                Count  Monthly Cost
module.vnet_creation.azurerm_bastion_host.bastion["hub-bastion"]                            1          $139
module.vnet_creation.azurerm_public_ip.bastion_pip["hub-bastion"]                           1            $4
azurerm_resource_group.rg                                                                   1            $0
module.vnet_creation.azurerm_monitor_diagnostic_setting.bastion_diag["hub-bastion"]         1            $0
module.vnet_creation.azurerm_virtual_network.vnet["hub"]                                    1            $0
module.vnet_creation.azurerm_virtual_network.vnet["spoke1"]                                 1            $0
module.vnet_creation.azurerm_log_analytics_workspace.law                                    1            $0
module.vnet_creation.azurerm_network_security_group.nsg["hub-vm"]                           1            $0
module.vnet_creation.azurerm_network_security_group.nsg["spoke1-app"]                       1            $0
module.vnet_creation.azurerm_subnet.subnet["hub-bastion"]                                   1            $0
module.vnet_creation.azurerm_subnet.subnet["hub-vm"]                                        1            $0
module.vnet_creation.azurerm_subnet.subnet["spoke1-app"]                                    1            $0
module.vnet_creation.azurerm_subnet_network…oup_association.subnet_nsg_assoc["hub-vm"]      1            $0
module.vnet_creation.azurerm_subnet_network…association.subnet_nsg_assoc["spoke1-app"]      1            $0
```

### Available Hooks

- Wilst stand-alone module uses `infracost scan` the hook ID in `antonbabenko/pre-commit-terraform` has not caught up with this change yet.
- https://github.com/antonbabenko/pre-commit-terraform#available-hooks presently shows hook  `infracost_breakdown` and is used in the pre-commit yaml file

### Testing Infracost via GHA

- Create a PR to trigger the infracost workflow
