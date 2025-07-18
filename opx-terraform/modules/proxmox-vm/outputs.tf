output "vm_ids" {
  value       = { for name, vm in proxmox_virtual_environment_vm.vm : name => vm.vm_id }
  description = "Map of VM names to VM IDs"
}
