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