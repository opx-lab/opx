########## MODULE: proxmox-firewall ##########

variable "vm_id" {
  description = "VM ID to apply firewall rules to"
  type        = number
}

variable "name" {
  description = "ipset address"
  type       = string
 
}

variable "proxmox_host" {
  description = "Proxmox node name"
  type        = string
}

variable "create_aliases" {
  type    = bool
  default = false
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

variable "internet_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/1", "128.0.0.0/1"] # override in root if you like
}