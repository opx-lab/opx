
# IP Sets
resource "proxmox_virtual_environment_firewall_ipset" "trusted_internal" {
  count     = local.make_aliases ? 1 : 0
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
   cidr {
    name    = "192.168.1.0/24"
    comment = "trusted LAN 4"
  }
}

# IP Set: dns-servers with multiple IP entries
resource "proxmox_virtual_environment_firewall_ipset" "dns_servers" {
  count   = local.make_aliases ? 1 : 0
  name    = "dns-servers"
  comment = "Public DNS servers"

  dynamic "cidr" {
    for_each = local.dns_ipset
    content {
      name    = cidr.key
      comment = cidr.value
    }
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
  cidr      = "192.168.55.10"
  comment   = "Management VM IP"
}

resource "proxmox_virtual_environment_firewall_alias" "loadbalancer" {
  count     = local.make_aliases ? 1 : 0
  node_name = var.proxmox_host
  name      = "loadbalancer"
  cidr      = "192.168.60.10"
  comment   = "Load balancer VM IP"
}

