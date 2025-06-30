variable "vm_name" {
  type        = string
  description = "Name of the VM"
}

variable "node" {
  type        = string
  description = "Proxmox node name"
}

variable "cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 1
}

variable "memory" {
  type        = number
  description = "RAM in MB"
  default     = 512
}

variable "disk_size" {
  type        = string
  description = "Disk size with unit (e.g., 8G)"
  default     = "8G"
}

variable "storage" {
  type        = string
  description = "Storage name in Proxmox"
  default     = "local-lvm"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "iso_path" {
  type        = string
  description = "Path to ISO in Proxmox storage"
  default     = "local:iso/ubuntu-22.04-live-server-amd64.iso"
}
