## Security

### Installing checkov

`Checkov` is especially useful — it will flag insecure configs (open security groups, missing encryption, etc.) before you ever deploy.

```bash
brew install pipx
pipx ensurepath
pipx install checkov

source ~/.zshrc
```

### pipx

`pipx` is specifically designed for Python CLI applications — it automatically manages a virtual environment per tool behind the scenes, so checkov is isolated and won't interfere with your Homebrew Python installation. It's the recommended modern approach on macOS for exactly this kind of situation.

### Output produced

```bash
checkov -d .                ✔  18:34:51
[ terraform framework ]: 100%|████████████████████|[10/10], Current File Scanned=versions.
[ secrets framework ]: 100%|████████████████████|[10/10], Current File Scanned=./modules/n

       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.2.530

terraform scan results:

Passed checks: 9, Failed checks: 0, Skipped checks: 0

Check: CKV_AZURE_183: "Ensure that VNET uses local DNS addresses"
	PASSED for resource: module.vnet_creation.azurerm_virtual_network.vnet["hub"]
	File: /modules/network/main.tf:15-23
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-183
Check: CKV_AZURE_182: "Ensure that VNET has at least 2 connected DNS Endpoints"
	PASSED for resource: module.vnet_creation.azurerm_virtual_network.vnet["hub"]
	File: /modules/network/main.tf:15-23
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-182
Check: CKV_AZURE_77: "Ensure that UDP Services are restricted from the Internet "
	PASSED for resource: module.vnet_creation.azurerm_network_security_group.nsg
	File: /modules/network/main.tf:42-52
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-udp-services-are-restricted-from-the-internet
Check: CKV_AZURE_10: "Ensure that SSH access is restricted from the internet"
	PASSED for resource: module.vnet_creation.azurerm_network_security_group.nsg
	File: /modules/network/main.tf:42-52
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-3
Check: CKV_AZURE_9: "Ensure that RDP access is restricted from the internet"
	PASSED for resource: module.vnet_creation.azurerm_network_security_group.nsg
	File: /modules/network/main.tf:42-52
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-2
Check: CKV_AZURE_160: "Ensure that HTTP (port 80) access is restricted from the internet"
	PASSED for resource: module.vnet_creation.azurerm_network_security_group.nsg
	File: /modules/network/main.tf:42-52
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-azure-http-port-80-access-from-the-internet-is-restricted
Check: CKV_AZURE_183: "Ensure that VNET uses local DNS addresses"
	PASSED for resource: module.vnet_creation.azurerm_virtual_network.vnet["spoke1"]
	File: /modules/network/main.tf:15-23
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-183
Check: CKV_AZURE_182: "Ensure that VNET has at least 2 connected DNS Endpoints"
	PASSED for resource: module.vnet_creation.azurerm_virtual_network.vnet["spoke1"]
	File: /modules/network/main.tf:15-23
	Calling File: /main.tf:12-19
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-182
Check: CKV2_AZURE_31: "Ensure VNET subnet is configured with a Network Security Group (NSG)"
	PASSED for resource: module.vnet_creation.azurerm_subnet.subnet
	File: /modules/network/main.tf:55-62
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/bc-azure-2-31
  ```