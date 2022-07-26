#' Assignments for all dyes screens
#'
#' A dataset containing all proteins and dyes screened, and the resulting assignment. Also includes screening conditions.
#'
#' @format A data frame with 22,223 rows rows and 19 variables:
# \describe{
#   \item{protein_name}{abbreviated name of screened protein}
#   \item{exp_num}{experiment number of the screen}
#   \item{dye_f}{name of dye, as a factor based on chemical similarity}
#   \item{assignment}{assignment given to that dye protein pair (none, hit, sensitive, untested)}
#   \item{screen_name}{full name of the screening data file}
#   \item{category}{name of the protein category, e.g. COVID}
#   \item{full_protein_name}{full, human-readable name of the protein}
#   \itme{construct_details}
#   ...
# }
"heatmap"