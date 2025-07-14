# github vars
variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username for team membership"
  type        = string
}


variable "team_memberships" {
  description = "Map of team names to list of usernames"
  type = map(list(string))
  default = {
    #admins         = ["test1"]
    #secops         = ["test2"]
    #developers     = ["test3"]
    }
}

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

# variables used by Proxmox VM module, VMs creation
variable "vms" {
  type = map(object({
    cpu_cores   = number
    memory      = number
    disk_size   = number
    pxe         = bool
    onboot      = bool
    ip_address = string
    subnet      = string
  }))

  default = {
    mgmt-vm = { cpu_cores=3, memory=5120, disk_size=25, pxe=false, onboot=true, ip_address="192.168.55.10", subnet="192.168.55.0/24" }
    monitor-vm = { cpu_cores=2, memory=2048, disk_size=15, pxe=false, onboot=true, ip_address="192.168.55.20", subnet="192.168.55.0/24" }
   # docker-vm = { cpu_cores=2, memory=2048, disk_size=15, pxe=false, onboot=false, ip_address="192.168.55.30" }
   # lb-vm = { cpu_cores=1, memory=1024, disk_size=10, pxe=false, onboot=false, ip_address="192.168.55.40" }
   # k8smaster-vm = { cpu_cores=2, memory=2048, disk_size=30, pxe=false, onboot=false, ip_address="192.168.55.50" }
   # k8sworker-vm = { cpu_cores=2, memory=2048, disk_size=30, pxe=false, onboot=false, ip_address="192.168.55.60" }
   # db-vm = { cpu_cores=2, memory=4096, disk_size=30, pxe=false, onboot=false, ip_address="192.168.55.70" }
  }
}