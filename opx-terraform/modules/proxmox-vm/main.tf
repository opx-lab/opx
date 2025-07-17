resource "proxmox_virtual_environment_vm" "vm" {
  name       = var.name
  node_name  = var.proxmox_host

  clone {
    vm_id = 9001
  }

  agent {
    enabled = true
  }
  
  vm_id = var.vm_id

  cpu {
    cores  = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }
  
  disk {
    datastore_id = "local"
    size     = var.disk_size
    interface = "scsi0"
    iothread = true
  }

  serial_device {}
  
  network_device {
    bridge = "vmbr0"
  }

    initialization {
       datastore_id         = "local"
    ip_config {
      ipv4 {
        address = "${var.ip_address}"
        gateway = var.gateway
      }
    }
  }
}

#   resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
#   content_type = "import"
#   datastore_id = "local"
#   node_name    = var.proxmox_host
#   url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
#   # need to rename the file to *.qcow2 to indicate the actual file format for import
#   file_name = "jammy-server-cloudimg-amd64.qcow2"
# }

  
  
#   clone       = var.template_name
#   agent       = 1
#   os_type     = "cloud-init"

#   cpu {
#     cores   = var.cpu_cores
#     sockets = 1
#   }

#   serial {
#     id   = 0
#     type = "socket"
#   }

#   scsi_hw = "virtio-scsi-pci"

#   disk {
#     id       = 0
#     size     = var.disk_size
#     storage  = "local"
#     iothread = true
#     discard  = true
#     type     = "scsi"
#   }

#   network {
#     id        = 0
#     bridge    = "vmbr0"
#     firewall  = false
#     link_down = false
#     model     = "virtio"
#   }

#   boot_order = ["scsi0"]

#   ipconfig0 = "ip=${var.ip_address},gw=${var.gateway}"

#   # sshkeys = var.ssh_key
# }