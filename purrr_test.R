library(tidyverse)
library(gh)

outputDir <- "485_responses"
path_dropbox <- "~/dropbox/"
path_csv_files <- paste0(path_dropbox, outputDir)

# import csv files --------------------------------------------------------
# Based on this blog post by Claus Wilke
# https://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R
# See the comments for map_dfr(), which I changed to map to keep
# students as list structure.

#students <- files %>% 
#  map_dfr(~ read_csv(file.path(path_csv_files, .)))

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


gh_post <- function(last_name, first_name, user_name) {
  gh::gh("POST /orgs/:org/repos",
        org = "SEMO-GABD",
        description = paste("This repo belongs to", user_name),
        name = paste(last_name, first_name, sep = "_"),
        team_id = 2935903,
        auto_init = TRUE,
        gitignore_template = "R",
        gitlicense_template = "mit",
        has_wiki = FALSE)
}
  

stu_list %>% pmap(gh_post)



# Working example of pasting two names together
my_func <- function(x, y) {paste(x, y, sep = "_")}

lst_nm <- students %>% map_chr("last_name")
fst_nm <- students %>% map_chr("first_name")
map2_chr(lst_nm, fst_nm, my_func)


