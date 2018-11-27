# Based on Git API 3.0
# https://developer.github.com/v3/

library(gh)


# REPOS -------------------------------------------------------------------

# To make a new repo
# gh("POST /orgs/SEMO-GABD/repos", name = "repo_name")
new_repo <- gh("POST /orgs/SEMO-GABD/repos", 
               name = "thecat_pipit")

user_name <- "Lynx the Cat"

new_repo <- gh("POST /orgs/:org/repos",
               org = "SEMO-GABD",
               description = paste("This repo belongs to", user_name),
               name = "test_repo",
               team_id = 2935903,
               auto_init = TRUE,
               gitignore_template = "R",
               gitlicense_template = "mit",
               has_wiki = FALSE)

# To delete the repo
# gh("DELETE /repos/SEMO-GABD/:repo"), e.g.,
gh("DELETE /repos/SEMO-GABD/:repo", 
   repo = "test_repo")


# COLLABORATORS -----------------------------------------------------------

# ADD a collaborator with default push permission
# gh("PUT /repos/:owner/:repo/collaborators/:username"), e.g.
gh("PUT /repos/:owner/:repo/collaborators/:username",
   owner = "SEMO-GABD",
   repo = "thecat_pipit",
   username = "3catacres")


gh("PUT /repos/:owner/:repo/collaborators/:username",
   owner = "SEMO-GABD",
   repo = "thecat_pipit",
   username = "3catacres",
   permission = "admin") # Overrides default "push"

# All examples can be hard-coded, but why?
gh("PUT /repos/SEMO-GABD/thecat_pipit/collaborators/3catacres")


# DELETE collaborator
# gh("DELETE /repos/:owner/:repo/collaborators/:username")
gh("DELETE /repos/:owner/:repo/collaborators/:username",
   owner = "SEMO-GABD",
   repo = "thecat_pipit",
   username = "3catacres")


# TEAMS -------------------------------------------------------------------

# To add a repo to a team
# PUT /teams/:team_id/repos/:owner/:repo,
# where ID is a number. The ID for students_2018 is 2935903.
gh("PUT /teams/2935903/repos/SEMO-GABD/thecat_pipit")

gh("PUT /teams/:team_id/repos/:owner/:repo",
   team_id = 2935903,
   owner = "SEMO-GABD",
   repo = "thecat_pipit")

# Programmic example,
id <- 2935903
owner_name <- "SEMO-GABD"
repo_name <- "thecat_pipit"
gh("PUT /teams/:team_id/repos/:owner/:repo",
   team_id = id,
   owner = owner_name,
   repo = repo_name)


# To get a list of teams for an org
# gh("GET /orgs/:org/teams")

# Best version for programming.
org_teams <- gh("GET /orgs/:org/teams", 
                org = "SEMO-GABD")


# CREATE a team
# gh("POST /orgs/:org/teams", name = "team_name")
team_info <- gh("POST /orgs/:org/teams", 
                name = "old_students", 
                org = "SEMO-GABD")

# DELETE a team
# gh("DELETE /teams/:team_id"),
# where :team_id is an id number.
gh("DELETE /teams/:team_id", team_id = 3019001)
