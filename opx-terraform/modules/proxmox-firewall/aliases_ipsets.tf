/*
  Terraform configuration file: firewall_aliases.tf

  This file defines Proxmox firewall aliases used across the homelab environment.
  Aliases group IP addresses and subnets under common names to simplify firewall
  rule management. Multiple resources with the same alias `name` combine their
  `cidr` entries into one effective alias.

  Variables:
    - var.proxmox_host: Proxmox node name where these aliases are applied.

  Aliases defined:
    - trusted-internal: All internal LAN subnets.
    - management: Management VM IP address.
    - loadbalancer: Load balancer VM IP address.
    - dns-servers: Public DNS servers.
    - internet: All IPv4 internet addresses (cluster-level alias).
*/

# IP Sets
resource "proxmox_virtual_environment_firewall_ipset" "trusted_internal" {
  count     = local.make_aliases ? 1 : 0
  node_name = var.proxmox_host
  name      = "trusted-internal"
  comment   = "Trusted internal networks"
 cidr {
    name    = "192.168.55.0/24"
    comment = "trusted LAN 1"
  }

  cidr {
    name    = "192.168.60.0/24"
    comment = "trusted LAN 2"
  }
  cidr {
    name    = "192.168.61.0/24"
    comment = "trusted LAN 3"
  }
}

# IP Set: dns-servers with multiple IP entries
resource "proxmox_virtual_environment_firewall_ipset" "dns_servers" {
  count     = local.make_aliases ? 1 : 0
  node_name = var.proxmox_host
  name      = "dns-servers"
  comment   = "Public DNS servers"
  cidr {
    name    = "8.8.8.8/32"
    comment = "DNS Server 1"
  }

  cidr {
    name    = "8.8.4.4/32"
    comment = "DNS Server 2"
  }

}

# IP Set: internet covering all IPs
resource "proxmox_virtual_environment_firewall_ipset" "int" {
  count     = local.make_aliases ? 1 : 0
  name    = "internet"
  comment = "All internet addresses"
  dynamic "cidr" {
    for_each = var.internet_cidrs
    content {
      name = cidr.value
    }
  }
}


### Aliases ###
resource "proxmox_virtual_environment_firewall_alias" "management" {
  count     = local.make_aliases ? 1 : 0
  node_name = var.proxmox_host
  name      = "management"
  cidr      = "192.168.55.10/32"
  comment   = "Management VM IP"
}

resource "proxmox_virtual_environment_firewall_alias" "loadbalancer" {
  count     = local.make_aliases ? 1 : 0
  node_name = var.proxmox_host
  name      = "loadbalancer"
  cidr      = "192.168.60.10/32"
  comment   = "Load balancer VM IP"
}

