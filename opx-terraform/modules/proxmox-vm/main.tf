resource "proxmox_vm_qemu" "vm" {
  name        = "terraform-connection-test"
  target_node = var.node

  cores  = 1
  memory = 512

  disk {
    size    = "1G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
}