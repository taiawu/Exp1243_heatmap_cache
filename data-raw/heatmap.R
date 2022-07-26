## code to prepare `heatmap` dataset goes here
# read in the updated heatmap, kept in Exp1351
heatmap <- base::readRDS("~/Box Sync/data/Exp1351--20220725_dye_screen_explorer_functions/3_read_by_app/heatmap.rds")

#### add code here to make any further changes to heatmap

## use_data attaches final object to package
usethis::use_data(heatmap, overwrite = TRUE)
