output "applied_rules" {
  value       = proxmox_virtual_environment_firewall_rules.vm_rules
  description = "Firewall rules applied to VM"
}