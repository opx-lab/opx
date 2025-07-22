# VMs creation using Terraform & proxmox-vm module
module "proxmox-vm" {
  source = "./modules/proxmox-vm"
  vms    = var.vms
  vm_user = var.vm_user
  vm_user_password = var.vm_user_password
}
output "all_vm_ids" {
  value = module.proxmox-vm.vm_ids
}

# Create aliases once


# Firewall configuration for each VM
# Create aliases once, no rules
module "proxmox_firewall_aliases" {
  name     = "global_aliases"
  vm_id    = null
  source        = "./modules/proxmox-firewall"
  proxmox_host   = local.default_node
  create_aliases = true
  firewall_rules = []
}

# Create firewall rules per VM, no alias creation
module "proxmox-firewall" {
  for_each       = var.vms
  source         = "./modules/proxmox-firewall"
  vm_id          = each.value.vm_id
  name           = each.key
  proxmox_host   = local.default_node
  firewall_rules = lookup(each.value, "firewall_rules", [])
  create_aliases = false


  depends_on = [module.proxmox_firewall_aliases]
}