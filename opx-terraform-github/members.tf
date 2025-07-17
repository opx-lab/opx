locals {
  user_team_pairs = flatten([
    for team_name, users in var.team_memberships : [
      for user in users : {
        team_name = team_name
        username  = user
      }
    ]
  ])
}

resource "github_team_membership" "memberships" {
  for_each = {
    for pair in local.user_team_pairs : "${pair.team_name}-${pair.username}" => pair
  }

  team_id  = github_team.teams[each.value.team_name].id
  username = each.value.username
  role     = "member"

  depends_on = [github_team.teams]
}
