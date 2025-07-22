# Proxmox VE & Terraform integration variables
variable "pm_user" {
  description = "Proxmox VE user"
  type        = string
  default     = "terraform-prov@pve"
}

variable "pm_password" {
  description = "Proxmox VE password"
  type        = string
  sensitive   = true
}



variable "vm_user" {
  type        = string
  description = "Username to create on every opx-lab VM"
  default     = "opx"
}

variable "vm_user_password" {
  type        = string
  description = "Password for that user"
}
