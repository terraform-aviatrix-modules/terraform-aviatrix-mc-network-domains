# terraform-aviatrix-mc-network-domains

### Description
A module to simplify management of Aviatrix network domains and connection policies.
By default, this module will automatically create all network domains that are referred to in the connection policies. To change this behavior, set `manage_network_domains` to false.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | >= 1.1.0 | >= 6.7 | >= 2.22.0

### Usage Example
```hcl
module "network_domains" {
  source  = "terraform-aviatrix-modules/mc-network-domains/aviatrix"
  version = "v1.0.0"

  connection_policies = [
    ["green", "blue"],
    ["red", "yellow"],
    ["purple", "green"],
    ["silver", "green"],
  ]

  additional_domains = [
    "brown",
    "black",
  ]

  associations = {
    "spoke1" = { #When using the mc-spoke module, you can also create the association as part of that module by setting `network_domain`.
      network_domain = "green",
      transit_gw     = "transit1",
    },
    "vpn1" = {
      network_domain = "yellow",
      transit_gw     = "transit1",
    },
  }
}
```

### Variables
The following variables are required:

key | value
:--- | :---

The following variables are optional:

key | default | value 
:---|:---|:---
additional_domains | [] | A list of network domains to be created, for which there are no connection policies defined (yet)
associations | {} | A map with network domain associations
connection_policies | [] | A list of lists with connection policies
manage_network_domains | true | Determines whether this module is responsible for creating network domains

### Outputs
This module will return the following outputs:

key | description
:---|:---
connection_policies | A list of all connection policies known by this module.
network_domains | A list of all network domains known by this module.