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
  
  dynamic "network_device" {
  for_each = each.key == "lb-vm" ? [1, 2] : [1]
  content {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }
}

    initialization {
      user_account {
      username = var.vm_user
      password = var.vm_user_password
      }
       datastore_id         = "local"
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}"
        gateway = each.value.gateway
        
      }
    }
  }
}
