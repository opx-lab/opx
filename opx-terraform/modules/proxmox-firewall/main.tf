resource "proxmox_virtual_environment_firewall_options" "firewall_opts" {
  node_name     = var.node_name
  vm_id         = var.vm_id
  container_id  = var.container_id

  enabled       = var.enabled
  dhcp          = var.dhcp
  ipfilter      = var.ipfilter
  macfilter     = var.macfilter
  ndp           = var.ndp
  input_policy  = var.input_policy
  output_policy = var.output_policy
  radv          = var.radv

  log_level_in  = var.log_level_in
  log_level_out = var.log_level_out
}

resource "proxmox_virtual_environment_firewall_rules" "firewall" {
  node_name    = var.node_name
  vm_id        = var.vm_id
  container_id = var.container_id

  dynamic "rule" {
    for_each = var.rules
    content {
      action        = rule.value.action
      type          = rule.value.type
      comment       = lookup(rule.value, "comment", null)
      dest          = lookup(rule.value, "dest", null)
      dport         = lookup(rule.value, "dport", null)
      enabled       = lookup(rule.value, "enabled", true)
      iface         = lookup(rule.value, "iface", null)
      log           = lookup(rule.value, "log", null)
      macro         = lookup(rule.value, "macro", null)
      proto         = lookup(rule.value, "proto", null)
      source        = lookup(rule.value, "source", null)
      sport         = lookup(rule.value, "sport", null)
      security_group = lookup(rule.value, "security_group", null)
    }
  }
}