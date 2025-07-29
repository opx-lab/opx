# output "vm_names" {
#   description = "Names of all created VMs"
#   value       = [for vm in module.proxmox-vm : vm.name]
# }



# checks if firewall is enabled for each VM
output "firewall_enabled_values" {
  value = { for k, v in var.vms : k => lookup(v, "enable_firewall", true) }
}
