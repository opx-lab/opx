resource "proxmox_virtual_environment_firewall_options" "vm_firewall" {
  node_name = var.proxmox_host
  vm_id     = var.vm_id

  enabled = var.enable_firewall
}

resource "proxmox_virtual_environment_firewall_rules" "vm_rules" {
  node_name = var.proxmox_host
  vm_id     = var.vm_id

  dynamic "rule" {
    for_each = [for r in var.firewall_rules : r if r != null]
    content {
      type     = rule.value.type
      action   = rule.value.action
      source   = rule.value.source
      dest     = rule.value.dest
      macro    = rule.value.macro
      proto    = rule.value.proto
      dport    = rule.value.dport
      sport    = rule.value.sport
      enabled  = rule.value.enabled
      log      = rule.value.log
      comment  = rule.value.comment
      iface    = rule.value.iface
    }
  }
}


