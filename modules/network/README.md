## Code explanations

### Flatten subnets config

```text
locals {
  subnets = merge([
    for vnet_key, vnet in var.vnets : {
      for subnet_key, subnet in vnet.subnets :
      "${vnet_key}-${subnet_key}" => {
        vnet_key = vnet_key
        name     = subnet.name
        cidr_block   = subnet.cidr_block
        nsg      = try(subnet.nsg, null)
        bastion  = try(subnet.bastion, false)
      }
    }
  ]...)
}
```
### What This Code Does

This is a flattening pattern — it takes a nested map (VNets → Subnets) and collapses it into a single flat map so you can use `for_each` on subnets directly.

### Step by step breakdown

#### The problem it solves

The input data is nested

```text
vnets
  └── hub
        └── subnets
              ├── vm
              └── bastion
  └── spoke1
        └── subnets
              └── app
```

But `for_each` needs a flat map. You can't `for_each` over nested structures directly.

#### Layer 1 — Outer for (iterates VNets)

```terraform
for vnet_key, vnet in var.vnets :
```

Loops over each VNet. On each iteration:
- `vnet_key` = `"hub"` or `"spoke1"`
- `vnet` = the full VNet config object

#### Layer 2 — Inner `for` (iterates Subnets)

```terraform
for subnet_key, subnet in vnet.subnets :
"${vnet_key}-${subnet_key}" => { ... }
```

For each VNet, loops over its subnets and builds a new map entry. The key is a **composite key** joining both names:
| vnet_key | subnet_key | Resulting key |
|----------|------------|---------------|
| hub      | vm         | hub-vm        |
| hub      | bastion    | hub-bastion   |
| spoke1   | app        | spoke1-app    |

#### Layer 3 — `merge([...]...)`

The two `for` loops produce a **list of maps** (one map per VNet):

```terraform
[
  { "hub-vm" = {...}, "hub-bastion" = {...} },   # from hub
  { "spoke1-app" = {...} }                        # from spoke1
]
```

`merge()` collapses that list into one flat map. The `...` (splat) **unpacks the list** into individual arguments that `merge()` expects:

```terraform
merge(map1, map2)   # what merge() wants
merge([map1, map2]...)  # splat unpacks the list to achieve this
```

#### Layer 4 — The Value Object

```terraform
{
  vnet_key   = vnet_key          # "hub" — used to look up the parent VNet later
  name       = subnet.name       # actual Azure resource name
  cidr_block = subnet.prefix     # e.g. "vm", or null
  nsg        = try(subnet.nsg, null)    # graceful — returns null if nsg key missing
  bastion    = try(subnet.bastion, false) # graceful — defaults false if key missing
}
```

`try()` is important here — it prevents errors when a subnet doesn't define `nsg` or `bastion` at all (not just set to `null`, but completely absent from the config).