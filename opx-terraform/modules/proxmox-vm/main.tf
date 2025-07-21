resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  name       = each.key
  vm_id     = each.value.vm_id
  node_name  = "opx-pc" # Use the default node name or set it dynamically

  clone {
    vm_id = 9001
  }

  agent {
    enabled = true
  }

  cpu {
    cores  = each.value.cpu_cores
  }

  memory {
    dedicated = each.value.memory
  }
  
  disk {
    datastore_id = "local"
    size     = each.value.disk_size
    interface = "scsi0"
    iothread = false
  }

  serial_device {}
  
  network_device {
    bridge = "vmbr0"
  }

    initialization {
       datastore_id         = "local"
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}"
        gateway = each.value.gateway
      }
    }
  }
}
