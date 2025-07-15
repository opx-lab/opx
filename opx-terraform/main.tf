# VMs creation using Terraform & proxmox-vm module
module "proxmox-vm" {
  source = "./modules/proxmox-vm"

  for_each = var.vms

  name       = each.key
  cpu_cores  = each.value.cpu_cores
  memory     = each.value.memory
  disk_size  = each.value.disk_size
  pxe        = each.value.pxe
  onboot     = each.value.onboot
  ip_address = each.value.ip_address
  gateway    = each.value.gateway
}
