resource "proxmox_vm_qemu" "vm" {
  name       = var.name
  memory     = var.memory
  onboot     = var.onboot

  target_node = var.proxmox_host
  clone = var.template_name
  agent = 1
  os_type = "cloud-init"

  
  cpu {
    cores   = var.cpu_cores
    sockets = 1
  }

  serial {
    id    = 0
    type  = "socket"
  }

  scsihw = "virtio-scsi-pci"

    # Setup the disk
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "local"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = var.disk_size
                    storage         = "local"
                    iothread        = true
                    discard         = true
                }
            }
        }
    }

#### FOR CLOUD INIT CONFIGURATION
  cicustom = <<EOF
#cloud-config
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - ${var.ip_address}/24
      gateway4: 192.168.55.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF
#####
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }
  

   boot = "order=scsi0"

  #sshkeys = var.ssh_key
}
