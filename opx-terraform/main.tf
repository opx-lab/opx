# VMs creation using Terraform & proxmox-vm module
module "proxmox-vm" {
  source = "./modules/proxmox-vm"

  for_each = var.vms

  name       = each.key
  vm_id      = each.value.vm_id
  cpu_cores  = each.value.cpu_cores
  memory     = each.value.memory
  disk_size  = each.value.disk_size
  pxe        = each.value.pxe
  onboot     = each.value.onboot
  ip_address = each.value.ip_address
  gateway    = each.value.gateway
}

output "all_vm_ids" {
  value = module.proxmox-vm.vm_ids
}





########################
########################
########################
# Proxmox VM firewall rules module
module "mgmt_vm_firewall" {
  source = "./modules/proxmox-firewall"

  vm_id           = module.proxmox-vm["mgmt-vm"].vm_id
  firewall_config = var.firewall_config
}