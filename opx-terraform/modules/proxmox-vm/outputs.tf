output "vm_ids" {
  value = { for vm_name, vm in proxmox_virtual_environment_vm : vm_name => vm.vm_id }
  description = "Map of VM names to VM IDs"
}