# VMs creation using Terraform & proxmox-vm module
module "proxmox-vm" {
  source = "./modules/proxmox-vm"
  vms    = var.vms
}

#   name       = each.key
#   vm_id      = each.value.vm_id
#   cpu_cores  = each.value.cpu_cores
#   memory     = each.value.memory
#   disk_size  = each.value.disk_size
#   pxe        = each.value.pxe
#   onboot     = each.value.onboot
#   ip_address = each.value.ip_address
#   gateway    = each.value.gateway
# }

output "all_vm_ids" {
  value = module.proxmox-vm.vm_ids
}





################################

module "firewall-mgmt-vm" {
  source         = "./modules/proxmox-firewall"
  vm_id          = module.proxmox-vm.vm_ids["mgmt-vm"]
  proxmox_host   = local.default_node
  firewall_rules = [
  {
    type     = "in"
    action   = "ACCEPT"
    proto    = "tcp"
    dport    = "22"
    comment  = "Allow SSH from internal"
    source   = "192.168.0.0/16"
    log      = "info"
    iface    = "net0"
    enabled  = true
    pos      = 10
  },
  {
    type     = "in"
    action   = "ACCEPT"
    proto    = "icmp"
    comment  = "Allow ICMP (ping)"
    source   = "192.168.0.0/16"
    log      = "info"
    iface    = "net0"
    enabled  = true
    pos      = 20
  },
  {
    type     = "in"
    action   = "ACCEPT"
    proto    = "tcp"
    dport    = "8006"
    comment  = "Allow Proxmox web UI"
    source   = "192.168.0.0/16"
    log      = "info"
    iface    = "net0"
    enabled  = true
    pos      = 30
  },
  {
    type     = "in"
    action   = "DROP"
    comment  = "Drop all other inbound traffic"
    log      = "info"
    enabled  = true
    pos      = 99
  }
]
}
# module "firewall-monitor-vm" {
#   source         = "./modules/proxmox-firewall"
#   vm_id          = module.proxmox-vm.vm_ids["monitor-vm"]
#   proxmox_host   = local.default_node
#   firewall_rules = [
#     {
#       type    = "in"
#       action  = "ACCEPT"
#       proto   = "tcp"
#       dport   = "22"
#       comment = "Allow SSH"
#     },
#   ]
# }
