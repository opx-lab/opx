# output "vm_names" {
#   description = "Names of all created VMs"
#   value       = [for vm in module.proxmox-vm : vm.name]
# }



# checks if firewall is enabled for each VM
output "firewall_enabled_values" {
  value = { for k, v in var.vms : k => lookup(v, "enable_firewall", true) }
}

# outputs.tf
output "user_password" {
  value     = var.vm_user   # or random_password.opx_user.result

}

output "user_username" {
  value = var.vm_user_password
  sensitive = true
}