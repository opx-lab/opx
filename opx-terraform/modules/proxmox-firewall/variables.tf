variable "node_name" {
  description = "Node name where the VM/container is hosted."
  type        = string
  default     = "opx-pc"
}

variable "vm_id" {
  description = "VM ID. Leave empty for cluster level rules."
  type        = number
}

variable "container_id" {
  description = "Container ID. Leave empty for cluster level rules."
  type        = number
  default     = null
}

variable "dhcp" {
  description = "Enable DHCP."
  type        = bool
  default     = false
}

variable "enabled" {
  description = "Enable or disable the firewall."
  type        = bool
  default     = true
}

variable "ipfilter" {
  description = "Enable default IP filters."
  type        = bool
  default     = false
}

variable "log_level_in" {
  description = "Log level for incoming packets."
  type        = string
  default     = "info"
}

variable "log_level_out" {
  description = "Log level for outgoing packets."
  type        = string
  default     = "info"
}

variable "macfilter" {
  description = "Enable or disable MAC address filter."
  type        = bool
  default     = false
}

variable "ndp" {
  description = "Enable Neighbor Discovery Protocol."
  type        = bool
  default     = false
}

variable "input_policy" {
  description = "Default input policy (ACCEPT, DROP, REJECT)."
  type        = string
  default     = "DROP"
}

variable "output_policy" {
  description = "Default output policy (ACCEPT, DROP, REJECT)."
  type        = string
  default     = "ACCEPT"
}

variable "radv" {
  description = "Enable Router Advertisement."
  type        = bool
  default     = false
}

variable "rules" {
  description = "List of firewall rules."
  type = list(object({
    action        = string
    type          = string
    comment       = optional(string)
    source        = optional(string)
    dest          = optional(string)
    dport         = optional(string)
    sport         = optional(string)
    proto         = optional(string)
    macro         = optional(string)
    enabled       = optional(bool, true)
    iface         = optional(string)
    log           = optional(string)
    security_group = optional(string)
  }))
  default = []
}
