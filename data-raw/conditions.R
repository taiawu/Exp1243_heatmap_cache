## code to prepare `heatmap` dataset goes here
# read in the updated heatmap, kept in Exp1351
conditions <- base::readRDS("~/Box Sync/data/Exp1351--20220725_dye_screen_explorer_functions/3_read_by_app/conditions.rds")

#### add code here to make any further changes to heatmap## code to prepare `conditions` dataset goes here

usethis::use_data(conditions, overwrite = TRUE)
