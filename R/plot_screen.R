pull_dataset <- 
  function(input_data, 
           .protein,
           .protein_col = "identity",
           .exp_col = "exp_num") {
    exp_test <-
      input_data %>%
      dplyr::filter(.data[[.protein_col]] == .protein) %>%
      dplyr::pull(.data[[.exp_col]]) %>%
      base::unique()
    
    out <- 
      input_data %>%
      dplyr::filter(.data[[.exp_col]] == exp_test)
    
  }

plot_one <- 
  function(data,
           .protein,
           .dye,
           .dye_col = "dye",
           .protein_col = "identity"
  ){
    
    plot_dat <-  
      pull_dataset(all_dat_df, 
                   .protein = .protein)
    
    p <- 
      plot_dat%>%
      dplyr::filter(.data[[.dye_col]] == .dye) %>%
      plot_dye_screen() +
      ggplot2::theme_minimal() +
      ggplot2::theme(panel.grid.minor =  element_blank())
  }

# p_out <- 
#   plot_one(all_dat_df, 
#            .protein = proteins[[1]], 
#            .dye = dyes[[1]])