# VMs creation using Terraform & proxmox-vm module
module "proxmox-vm" {
  source = "./modules/proxmox-vm"
  vms    = var.vms
}
output "all_vm_ids" {
  value = module.proxmox-vm.vm_ids
}


# Firewall configuration for each VM
module "firewall" {
  for_each      = var.vms
  source        = "./modules/proxmox-firewall"
  vm_id         = each.value.vm_id
  proxmox_host  = local.default_node
  firewall_rules = lookup(each.value, "firewall_rules", [])
}