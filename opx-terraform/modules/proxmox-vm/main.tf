resource "proxmox_vm_qemu" "vm" {
  name       = var.name
  memory     = var.memory
  onboot     = var.onboot
  pxe        = var.pxe

  cpu {
    cores   = var.cpu_cores
    sockets = 1
    type    = "host"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size      = var.disk_size
          storage   = "local"
          backup    = true
          cache     = "none"
          discard   = true
          emulatessd= true
          iothread  = true
          replicate = false
        }
      }
    }
  }

  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"
  }

  balloon                   = 0
  bios                      = "seabios"
  boot                      = "order=scsi0;net0"
  define_connection_info    = true
  force_create              = false
  hotplug                   = "network,disk,usb"
  kvm                       = true
  os_type                   = "Linux 5.x - 2.6 Kernel"
  qemu_os                   = "l26"
  scsihw                    = "virtio-scsi-pci"
  tablet                    = true
  target_node               = "opx-pc"
}