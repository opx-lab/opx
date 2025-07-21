########## MODULE: proxmox-firewall ##########

variable "vm_id" {
  description = "VM ID to apply firewall rules to"
  type        = number
}

variable "proxmox_host" {
  description = "Proxmox node name"
  type        = string
}

# This defines the firewall configuration for the Proxmox VM
variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    type     = string
    action   = string
    source   = optional(string)
    dest     = optional(string)
    macro    = optional(string)
    proto    = optional(string)
    dport    = optional(string)
    sport    = optional(string)
    enabled  = optional(bool, true)
    log      = optional(string)
    comment  = optional(string)
    iface    = optional(string)
    pos      = optional(number)
  
  }))
  default = []
}