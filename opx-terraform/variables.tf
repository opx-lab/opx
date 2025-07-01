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