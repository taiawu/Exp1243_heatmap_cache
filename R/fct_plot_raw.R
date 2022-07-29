#' plot_raw 
#'
#' @description A funcion to plot raw screen results
#'
#' @return A ggproto object containing a plot of the raw data
#' 
#'
#' @noRd # will not make a doc file for it, which is fine bc its not exported
#' 
plot_raw <-
  function(tidied_screen,
           .temp_col = "Temperature",
           .value_col = "value",
           .color_col = "channel_f",
           .linetype_col = "type",
           .variable_col = "var_num",
           .line_size = 0.3,
           .line_alpha = 0.8,
           .color_legend_title = "Channel",
           .linetype_legend_title = "",
           .scale_color_vals  = c("Cy5.5" = "#67000d", "Cy5" = "#a50f15", "ROX" = "#ef3b2c", "TAMRA" = "#f16913", "JOE" = "#74c476", "FAM" = "#2171b5"),
           .scale_linetype_vals = c("buffer" = "dashed","protein" = "solid"),
           .use_default_x_scaling = TRUE,
           .x_scale_breaks = NULL,
           ...) {
    
    # a barely-modified version of sfworld::plot_dye_screen() 
    # simpler dependencies to just do it this way
    # from ggplot2 ggplot, aes, geom_line scale_color_manual scale_linetype_manual labs scale_x_continuous
    # from hrbrthemes theme_ipsum
    
    if(.use_default_x_scaling) {
      .x_breaks <-   seq(from = min(tidied_screen[[.temp_col]]), to = max(tidied_screen[[.temp_col]]), by = 10)
    } else {
      .x_breaks <- .x_scale_breaks
    }
    
    p <- tidied_screen %>%
      ggplot2::ggplot(
        ggplot2::aes(x = Temperature, # temperature on X
                     y  = value, # RFU on y
                     color    = channel_f, # colored by the state
                     linetype = type,
                     group    = var_num) # group means series, as in, this defines the unique data sets
        # ggplot2::aes(x        = .data[[.temp_col]], # temperature on X
        #              y        = .data[[.value_col]], # RFU on y
        #              color    = .data[[.color_col]], # colored by the state
        #              linetype = .data[[.linetype_col]],
        #              group    = .data[[.variable_col]]) # group means series, as in, this defines the unique data sets
      ) +
      
      # geoms
      ggplot2::geom_line(size = .line_size,
                         alpha = .line_alpha) + # change the line type depending on the dye concentration # linetype = df_melt$conc #
      
      # manual aesthetic mappings
      ggplot2::scale_color_manual( values = .scale_color_vals) +
      ggplot2::scale_linetype_manual(values = .scale_linetype_vals) +
      
      # legend labels
      ggplot2::labs(color = .color_legend_title,
                    linetype = .linetype_legend_title,
                    x = "Temperature (ºC)",
                    y = "RFU") +
      
      # themes
      hrbrthemes::theme_ipsum(base_size = 16) +
      ggplot2::theme(aspect.ratio = 1/1.617) +
      # axis styling
      ggplot2::scale_x_continuous(breaks = .x_breaks)
    
    p
    
  }