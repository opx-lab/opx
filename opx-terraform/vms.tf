# Firewall baseline rules applied to VMs with firewall enabled

# VM definitions
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
      vm_id           = 101
      cpu_cores       = 3
      memory          = 5120
      disk_size       = 25
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.10/24"
      gateway         = "192.168.55.2"
      enable_firewall = true

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]

    }
    monitor-vm = {
      vm_id           = 102
      cpu_cores       = 2
      memory          = 2048
      disk_size       = 15
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.20/24"
      gateway         = "192.168.55.2"
      enable_firewall = true

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]

    }
    docker-vm = {
      vm_id           = 103
      cpu_cores       = 2
      memory          = 2048
      disk_size       = 15
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.30/24"
      gateway         = "192.168.55.2"
      enable_firewall = true

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]

    }
    lb-vm = {
      vm_id           = 104
      cpu_cores       = 1
      memory          = 1024
      disk_size       = 10
      pxe             = false
      onboot          = true
      ip_address      = "192.168.1.60/24"
      gateway         = "192.168.1.50"
      enable_firewall = false

    }
    k8smaster-vm = {
      vm_id           = 105
      cpu_cores       = 2
      memory          = 2048
      disk_size       = 30
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.40/24"
      gateway         = "192.168.55.2"
      enable_firewall = true
      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]



    }
    k8sworker-vm = {
      vm_id           = 106
      cpu_cores       = 2
      memory          = 2048
      disk_size       = 30
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.50/24"
      gateway         = "192.168.55.2"
      enable_firewall = true

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]

    }
    db-vm = {
      vm_id           = 107
      cpu_cores       = 2
      memory          = 4096
      disk_size       = 50
      pxe             = false
      onboot          = true
      ip_address      = "192.168.55.60/24"
      gateway         = "192.168.55.2"
      enable_firewall = true

      firewall_rules = [
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "+trusted-internal"
          proto   = "icmp"
          pos     = 10
          comment = "ICMP from internal"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "192.168.1.50"
          proto   = "tcp"
          dport   = "22"
          pos     = 20
          comment = "SSH from opx-pc"
        },
        {
          type    = "in"
          action  = "ACCEPT"
          source  = "management"
          proto   = "tcp"
          dport   = "22"
          pos     = 30
          comment = "SSH from mgmt-vm"
        },
        {
          type    = "in"
          action  = "DROP"
          pos     = 99
          comment = "Default drop inbound"
        },
        {
          type    = "out"
          action  = "ACCEPT"
          pos     = 10
          comment = "Allow outbound"
        }
      ]

    }
  }
}
