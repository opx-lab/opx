variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1y..."
}

variable "template_name" {
  default = "debian-12-cloudinit-template"
}

variable "vm_user" {
  type        = string
  description = "Username to create on every opx-lab VM"
  default     = "opx"
}

variable "vm_user_password" {
  type        = string
  description = "Password for that user"
  sensitive   = true
  default     = null
}

variable "vms" {
  type = map(object({
    vm_id      = number
    cpu_cores  = number
    memory     = number
    disk_size  = number
    pxe        = bool
    onboot     = bool
    ip_address = string
    gateway    = string
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
}

variable "template_vmid" {
  type        = number
  description = "VMID of the Proxmox template to clone"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys injected via cloud-init"
}


variable "target_node" {
  type        = string
  description = "Proxmox node name"
}