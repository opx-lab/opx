variable "vms" {
  type = map(object({
    cpu_cores       = number
    memory          = number
    disk_size       = number
    pxe             = bool
    onboot          = bool
    ip_address      = string
    gateway         = string
    vm_id           = number
    enable_firewall = optional(bool, true)
    firewall_rules = optional(list(object({
      type    = string
      action  = string
      source  = optional(string)
      dest    = optional(string)
      macro   = optional(string)
      proto   = optional(string)
      dport   = optional(string)
      sport   = optional(string)
      enabled = optional(bool, true)
      log     = optional(string)
      comment = optional(string)
      iface   = optional(string)
      pos     = optional(number)
    })), [])
  }))

  default = {
    # MANAGEMENT VM
    mgmt-vm = {
      vm_id      = 101
      cpu_cores  = 3
      memory     = 5120
      disk_size  = 25
      pxe        = false
      onboot     = true
      ip_address = "192.168.55.10/24"
      gateway    = "192.168.60.10"

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          proto   = "icmp"
          source  = "+trusted-internal"
          comment = "Ping from LAN"
          log     = "info"
          iface   = "net0"
          enabled = true
          pos     = 10
        },
        {
          type    = "in"
          action  = "ACCEPT"
          proto   = "tcp"
          dport   = "22"
          source  = "192.168.0.0/16"
          comment = "SSH from internal"
          log     = "info"
          iface   = "net0"
          enabled = true
          pos     = 20
        },
        {
          type    = "in"
          action  = "ACCEPT"
          proto   = "tcp"
          dport   = "8006"
          source  = "192.168.0.0/16"
          comment = "Proxmox UI from internal"
          log     = "info"
          iface   = "net0"
          enabled = true
          pos     = 30
        },
        {
          type    = "in"
          action  = "DROP"
          comment = "Default drop inbound"
          log     = "info"
          iface   = "net0"
          enabled = true
          pos     = 99
        },
        {
          type    = "out"
          action  = "ACCEPT"
          comment = "Allow all outbound"
          iface   = "net0"
          enabled = true
          pos     = 10
        }
      ]
    }

    # LOAD BALANCER
    lb-vm = {
      vm_id      = 104
      cpu_cores  = 1
      memory     = 1024
      disk_size  = 10
      pxe        = false
      onboot     = true
      ip_address = "192.168.60.10/24"
      gateway    = "192.168.1.50"
      enable_firewall = false
      firewall_rules = []  ### Empty, handled by opx-pc (proxmox host)
      
    }
  }
}


  #docker
    #   cpu_cores=2 
    #   memory=2048 
    #   disk_size=15 
    #   pxe=false 
    #   onboot=false 
    #   ip_address="192.168.55.30/24"
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
  
