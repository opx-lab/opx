terraform {
  required_version = ">= 1.1.0"
  required_providers {
    # GitHub provider for managing GitHub resources
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }

}

provider "github" {
  token = var.github_token
  owner = "opx-lab"
}