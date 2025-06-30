resource "github_team" "teams" {
  for_each = var.team_memberships

  name        = each.key
  description = "${each.key} team"
  privacy     = "closed"
}
