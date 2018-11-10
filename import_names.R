## Import student names from dropbox folder into single csv.
## Create GitHub directories for those students


# load packages -----------------------------------------------------------

# Need readr and purr

library("tidyverse")
library("gh")

# global_vars -------------------------------------------------------------

outputDir <- "485_responses"
path_dropbox <- "~/dropbox/"
path_csv_files <- paste0(path_dropbox, outputDir)
github_new_repo_path <- "/orgs/SEMO-GABD/repos"
github_del_repo_path <- "/repos/SEMO-GABD/"

# functions ---------------------------------------------------------------

make_student_directories <- function(dir_list = NULL) {
  if (length(dir_list) == 0) {
    return("Need vector of student names")
  } else {
    len <- length(dir_list)
    new_dir_path <- paste("POST", github_new_repo_path)
    for (i in 1:len){
      cat("Making", dir_list[i], "GitHub directory.\n")
      gh::gh(new_dir_path, name = dir_list[i])
    }
  }
}

delete_student_directories <- function(dir_list = NULL) {
  if (length(dir_list) == 0) {
    return("Need vector of student names")
  } else {
    len <- length(dir_list)
    for (i in 1:len){
      cat("Deleting", dir_list[i], "GitHub directory.\n")
      gh::gh(paste0("DELETE ", github_del_repo_path, dir_list[i]))
    }
  }
}


# import csv files --------------------------------------------------------
# Based on this blog post by Claus Wilke
# https://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R
# See the comments for map_dfr()

files <- dir(path = path_csv_files, pattern = "*.csv")
students <- files %>% 
  map_dfr(~ read_csv(file.path(path_csv_files, .)))

# write csv file ----------------------------------------------------------
#
# Store the file for long-term backup.
# Not sure if necessary, but for now....

# use `dir <- getwd()` or other path to set a 
# specific path for saving the file.
write_csv(students, "485_students.csv")

# Prep for GitHub ---------------------------------------------------------

students <- students %>% 
  mutate(github_dir = str_to_lower(paste0(last_name, "_", first_name)))


# Make Directories --------------------------------------------------------

# Use this to make student directories
make_student_directories(students$github_dir)



# Delete Directories ------------------------------------------------------

# Use this to delete student directories
# delete_student_directories(students$github_dir)

