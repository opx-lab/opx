variable "firewall_config" {
  description = "Firewall configuration map for the VM"
  type = object({
    enabled        = optional(bool, true)
    dhcp           = optional(bool, false)
    ipfilter       = optional(bool, true)
    macfilter      = optional(bool, false)
    ndp            = optional(bool, true)
    input_policy   = optional(string, "DROP")
    output_policy  = optional(string, "ACCEPT")
    log_level_in   = optional(string, "info")
    log_level_out  = optional(string, "info")
    radv           = optional(bool, false)
    rules          = optional(list(object({
      action  = string
      type    = string
      source  = optional(string)
      dest    = optional(string)
      proto   = optional(string)
      dport   = optional(string)
      sport   = optional(string)
      comment = optional(string)
      enabled = optional(bool, true)
    })), [])
  })
  default = {}
}