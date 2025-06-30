module "test_vm" {
  source         = "./modules/proxmox-vm"
  vm_name        = "test-vm"
  node           = "your-proxmox-node-name"  # Replace with your node name
  cores          = 1
  memory         = 512
  disk_size      = "8G"
  storage        = "local-lvm"
  network_bridge = "vmbr0"
  iso_path       = "local:iso/ubuntu-22.04-live-server-amd64.iso"
    providers = {
    proxmox = proxmox
  }
}