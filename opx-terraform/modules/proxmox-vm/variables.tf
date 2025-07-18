variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1y..."
}

variable "template_name" {
  default = "debian-12-cloudinit-template"
}

variable "vms" {
  description = "Map of virtual machines to create"
  type = map(object({
    vm_id      = number
    cpu_cores  = number
    memory     = number
    disk_size  = number
    pxe        = bool
    onboot     = bool
    ip_address = string
    gateway    = string
  }))
}
