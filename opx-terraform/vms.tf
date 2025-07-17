# variables used by Proxmox VM module, VMs creation
variable "vms" {
  type = map(object({
    cpu_cores  = number
    memory     = number
    disk_size  = number
    pxe        = bool
    onboot     = bool
    ip_address = string
    gateway    = string
    vm_id      = number
  }))

  default = {
    mgmt-vm = {
      vm_id      = 101
      cpu_cores  = 3
      memory     = 5120
      disk_size  = 25
      pxe        = false
      onboot     = true
      ip_address = "192.168.55.10/24"
      gateway="192.168.60.10"
      }

    monitor-vm = { 
      vm_id      = 102
      cpu_cores=2
      memory=2048
      disk_size=15
      pxe=false
      onboot=true
      ip_address="192.168.55.20/24"
      gateway="192.168.60.10"
      }

    # docker-vm = { 
    #   vm_id      = 103
    #   cpu_cores=2 
    #   memory=2048 
    #   disk_size=15 
    #   pxe=false 
    #   onboot=false 
    #   ip_address="192.168.55.30/24"
    #   gateway="192.168.60.10" 
    #   }

    # lb-vm = {
    #   vm_id      = 104
    #   cpu_cores=1
    #   memory=1024
    #   disk_size=10 
    #   pxe=false 
    #   onboot=false 
    #   ip_address="192.168.60.10/24"
    #   gateway="192.168.60.10"
    #   }

    # k8smaster-vm = {
    #    vm_id      = 105
    #    cpu_cores=2 
    #    memory=2048 
    #    disk_size=30 
    #    pxe=false 
    #    onboot=false 
    #    ip_address="192.168.55.40/24" 
    #    gateway="192.168.60.10"
    #    }

    # k8sworker-vm = {
    #    vm_id      = 106
    #    cpu_cores=2 
    #    memory=2048 
    #    disk_size=30
    #    pxe=false 
    #    onboot=false
    #    ip_address="192.168.55.50/24"
    #    gateway="192.168.60.10"
    #    }

    # db-vm = {
    #    vm_id      = 107
    #    cpu_cores=2 
    #    memory=4096 
    #    disk_size=30 
    #    pxe=false 
    #    onboot=false 
    #    ip_address="192.168.61.10/24" 
    #    gateway="192.168.60.10"
    #    }
  }
}