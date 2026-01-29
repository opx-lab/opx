resource "proxmox_virtual_environment_firewall_options" "vm_firewall" {
  for_each  = local.manage_vm ? { this = var.vm_id } : {}
  node_name = var.proxmox_host
  vm_id     = var.vm_id
  enabled   = true
  dhcp      = false
}

resource "proxmox_virtual_environment_firewall_rules" "vm_rules" {
  node_name = var.proxmox_host
  count     = var.vm_id != null ? 1 : 0
  vm_id     = var.vm_id

  dynamic "rule" {
    for_each = length(var.firewall_rules) > 0 ? var.firewall_rules : [
      {
        type    = "in"
        action  = "DROP"
        comment = "Default deny all inbound"
        enabled = true
      }
    ]

    content {
      type    = rule.value.type
      action  = rule.value.action
      source  = lookup(rule.value, "source", "")
      dest    = lookup(rule.value, "dest", "")
      macro   = lookup(rule.value, "macro", "")
      proto   = lookup(rule.value, "proto", "")
      dport   = lookup(rule.value, "dport", "")
      sport   = lookup(rule.value, "sport", "")
      enabled = lookup(rule.value, "enabled", true)
      log     = lookup(rule.value, "log", "")
      comment = lookup(rule.value, "comment", "")
      iface   = lookup(rule.value, "iface", "")
    }
  }
}


