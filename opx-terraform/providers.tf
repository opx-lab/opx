terraform {
  required_providers {
    # GitHub provider for managing GitHub resources
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
    # Proxmox provider for managing Proxmox VE resources
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.50:8006/api2/json"
  pm_user = var.pm_api_token_id
  pm_password = var.pm_api_token_secret
  pm_tls_insecure = true
}

provider "github" {
  token = var.github_token
  owner = "opx-lab"
}