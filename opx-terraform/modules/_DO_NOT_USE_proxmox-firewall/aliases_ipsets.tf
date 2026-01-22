
# IP Sets
resource "proxmox_virtual_environment_firewall_ipset" "trusted_internal" {
  count   = local.make_aliases ? 1 : 0
  name    = "trusted-internal"
  comment = "Trusted internal networks"

  cidr {
    name    = "192.168.55.0/24"
    comment = "opx-lab internal"
  }

  cidr {
    name    = "192.168.1.0/24"
    comment = "home LAN / upstream"
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
  count   = local.make_aliases ? 1 : 0
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

### LOAD BALANCER VM ###
resource "proxmox_virtual_environment_firewall_alias" "lb_wan" {
  count   = local.make_aliases ? 1 : 0
  name    = "lb-wan"
  cidr    = "192.168.1.60"
  comment = "LB WAN IP"
}

resource "proxmox_virtual_environment_firewall_alias" "lb_lan" {
  count   = local.make_aliases ? 1 : 0
  name    = "lb-lan"
  cidr    = "192.168.55.2"
  comment = "LB LAN gateway IP"
}

#############################

resource "proxmox_virtual_environment_firewall_alias" "management" {
  count     = local.make_aliases ? 1 : 0
 # node_name = var.proxmox_host
  name      = "management"
  cidr      = "192.168.55.10"
  comment   = "Management VM IP"
}
