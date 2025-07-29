terraform {
  cloud {
    organization = "opx-lab"       # plain ASCII hyphen
    workspaces {
      name = "opx-workspace"
    }
  }

  required_version = ">= 1.1.0"


  required_providers {
  # Proxmox provider for managing Proxmox VE resources
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {

  endpoint      = "https://192.168.1.50:8006/api2/json"
  username         = var.pm_user
  password     = var.pm_password
  insecure = true

  # debug log
  #pm_log_enable = true
  #pm_log_file = "terraform-plugin-proxmox.log"
  #pm_debug = true
  #pm_log_levels = {
  #  _default = "debug"
  #  _capturelog = ""
  #}
}
