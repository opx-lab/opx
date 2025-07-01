terraform {
  required_version = ">= 1.1.0"
  required_providers {
    # GitHub provider for managing GitHub resources
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
    # Proxmox provider for managing Proxmox VE resources
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "proxmox" {
  
  
  pm_api_url = "https://192.168.1.50:8006/api2/json"
  pm_user = var.pm_user
  pm_password = var.pm_password
  pm_tls_insecure = true
  
  #debug log
  #pm_log_enable = true
  #pm_log_file = "terraform-plugin-proxmox.log"
  #pm_debug = true
  #pm_log_levels = {
  #  _default = "debug"
  #  _capturelog = ""
  #}
}

provider "github" {
  token = var.github_token
  owner = "opx-lab"
}
