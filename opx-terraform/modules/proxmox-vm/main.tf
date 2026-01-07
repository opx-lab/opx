resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  name      = each.key
  vm_id     = each.value.vm_id
  node_name = "opx-pc" # Use the default node name or set it dynamically

  clone {
    vm_id = var.template_vmid
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu_cores
  }

  vga {
  type = "qxl"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local"
    size         = each.value.disk_size
    interface    = "scsi0"
    iothread     = false
  }

  serial_device {}

  dynamic "network_device" {
    for_each = each.key == "lb-vm" ? [1, 2] : [1]
    content {
      bridge   = "vmbr0"
      model    = "virtio"
      firewall = each.key != "lb-vm"
    }
  }

  initialization {
    user_account {
      username = var.vm_user
      keys     = var.ssh_public_keys
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data[each.key].id

    datastore_id = "local"
  
    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway

      }
    }
     dynamic "ip_config" {
    for_each = each.key == "lb-vm" ? [1] : []
    content {
      ipv4 {
        address = "192.168.55.2/24"
         }
       }
     }
  }
}

resource "proxmox_virtual_environment_file" "user_data" {
  for_each = var.vms

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    file_name = "user-data-${each.value.vm_id}.yaml"
    data = templatefile("${path.module}/cloudinit/user-data.yaml.tftpl", {
      username        = var.vm_user
      ssh_public_keys = var.ssh_public_keys
      hostname        = each.key
      
    })
  }
}