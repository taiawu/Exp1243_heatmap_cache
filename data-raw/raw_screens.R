## code to prepare `raw_screens` dataset goes here

# has exp_num overwritten as numbers. 
# a separate object maps exp_num to the actual number assigned here
# characters do not save efficiently, so making variable a numeric colum reduced the .rds size from 2.2 GB to ~1GB. Will this be enough? 

raw_screens <- base::readRDS("~/Box Sync/data/Exp1351--20220725_dye_screen_explorer_functions/1_intermediate/Exp1350--20220728_raw_screens_var_num.rds")

usethis::use_data(raw_screens, overwrite = TRUE)
