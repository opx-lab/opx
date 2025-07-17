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