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

variable "target_node" {
  type        = string
  description = "Proxmox node name"
}

variable "vm_user" {
  type        = string
  description = "Username to create on every opx-lab VM"
  default     = "opx"
}

# PRZETESTOWAC SSH
# variable "vm_user_password" {
#   type        = string
#   description = "Password for that user"
# }

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys injected via cloud-init"
}

variable "template_vmid" {
  type        = number
  description = "VMID of golden Debian cloud-init template"
}