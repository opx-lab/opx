variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1y..."
}

variable "proxmox_host" {
  default = "opx-pc"
}
variable "template_name" {
  default = "template-opx"
}

# This defines the custom variables used in the Proxmox VM module
variable "name" {
  type        = string
  description = "VM name"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Memory in MB"
  default     = 2048
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 32
}

variable "pxe" {
  type        = bool
  description = "Enable PXE boot"
  default     = true
}

variable "onboot" {
  type        = bool
  description = "Start VM on Proxmox boot"
  default     = false
}
