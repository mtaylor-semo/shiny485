
# PACKAGES ----------------------------------------------------------------

library(tidyverse)
library(gh)


# GLOBAL VARS -------------------------------------------------------------

outputDir <- "485_responses"
path_dropbox <- "~/dropbox/"
path_csv_files <- paste0(path_dropbox, outputDir)
org_name <- "SEMO-GABD" # Also functions as owner
team_ident <- 2935903 # Team number for Students_2018 team.


# FUNCTIONS ---------------------------------------------------------------
# Functions to make and manipulate repos on GitHub.
# See github_api_examples.R for other possibilities.

# Makes repos first
make_repos <- function(last_name, first_name, user_name, ...) {
  gh::gh("POST /orgs/:org/repos",
         org = org_name,
         description = paste("This repo belongs to", user_name),
         name = stringr::str_to_lower(paste(last_name, 
                                            first_name, 
                                            sep = "_")),
         team_id = team_ident,
         auto_init = TRUE,
         gitignore_template = "R",
         gitlicense_template = "mit",
         has_wiki = FALSE)
}

# Add the student as collaborator with default push access.
add_collaborator <- function(last_name, first_name, user_name, ...) {
  gh::gh("PUT /repos/:owner/:repo/collaborators/:username",
         owner = org_name,
         repo = paste(last_name, first_name, sep = "_"),
         username = user_name)
}

# MAIN --------------------------------------------------------------------

# Import and format data for purrr and gh

# Based on this blog post by Claus Wilke
# https://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R
# See the comments for map_dfr(), which I changed to map to keep
# students as list structure.

files <- dir(path = path_csv_files, pattern = "*.csv")
students <- files %>% 
  map(~ read_csv(file.path(path_csv_files, .)))


stu_list <- students %>% {
  tibble::tibble(
    last_name = map_chr(., "last_name"),
    first_name = map_chr(., "first_name"),
    user_name = map_chr(., "git_user")
  )
}

# Pipe the student list to the Git functions to configure them 
# on GitHub.

stu_list %>% pmap(make_repos)

stu_list %>% pmap(add_collaborator)


# TO DO -------------------------------------------------------------------

# Write a function that gets the team repos and extracts the team_id.
# Could just do this manually each year.

# IGNORE ------------------------------------------------------------------

# Working example of pasting two names together
my_func <- function(x, y) {paste(x, y, sep = "_")}

lst_nm <- students %>% map_chr("last_name") %>% stringr::str_to_lower(.)
fst_nm <- students %>% map_chr("first_name")
map2_chr(lst_nm, fst_nm, my_func)


