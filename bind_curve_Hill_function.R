###a function that provides a binding curve using the Hill Equation give excel data file input, and produces
#a plot of the binding curve, as well as the calculated Bmax, n, and Ka values and associated standard error
#due to the calibration.

###Automatically supplies 1 as starting points for all variables in non linear least squares regression
###tables must not have na values. (These are the cause of the Warning messages. For most data 1 is fine)

###file must be .xlsx and have a sheet titled "Import" with three columns of data:
  ###1st column: concentration of protein
  ###2nd column: change in y values (for example, change in anisotropy)
  ###3rd column: standard error of the mean for change in y.
  #columns can have any names, the order is important.

###function arguments:
  ###file = location of .xlsx file (~required~)
  ###title = graph title (default "Binding Curve")
  ###x_ax = x axis label (default "Thrombin Concentration (nM)")
  ###y_ax = y axis label (default "Change in Anisotropy")
  ###dps_ka = number of decimal places for k_a value (default 3)
  ###dps_bmax = number of decimal places for Bmax value (default 4)
  ###dps_n = number of decimal places for n value (default 4)
  ###return_obj = whether to return a plot or fit_df. Default is "plot", which returns ggplot plot
    ##set return_obj to "fit_df" to return a data frame with fit data that can be added to another plot

#By Simon D. Weaver
#Whelan Lab - University of Notre Dame
#Fall 2020

#example:
#     bind_curve_Hill("file.xlsx", dps_ka = 1, title = "Hill Function fit for Thrombin and 29mer",
#                     return_obj = "fit_df")



bind_curve_Hill <- function(file, title = "Binding Curve",
                                dps_ka = 3,
                                dps_n = 4,
                                dps_bmax = 4,
                                x_ax = "Thrombin Concentration (nM)",
                                y_ax = "Change in Anisotropy",
                                return_obj = "plot") {
  
  #suppress warnings (which are described in comments above)
  oldw <- getOption("warn")
  options(warn = -1)
  
  
  #load libraries for analysis
  library(ggplot2)
  library(dplyr)
  library(readxl)
  
  #Set plot label variables
  x_axis_label <- x_ax
  y_axis_label <- y_ax
  plot_title <- title
  
  #import dataset as dataframe: plot_data
  plot_data <- read_excel(file, 
                          sheet = "Import")
  
  #rename columns
  #"thrombin_conc" used as thrombin is a good model for Hill. Can be any target molecule
  colnames(plot_data) <- c("thrombin_conc", "change_y", "SEM")
  
  #Calculate the n value:
  #copy plot data
  statistics_table <- plot_data
  
  
  #find min and max x and y values
  max_x <- max(plot_data$thrombin_conc)
  min_x <- min(plot_data$thrombin_conc)
  max_y <- max(plot_data$change_y)
  min_y <- min(plot_data$change_y)
  
  #calculate columns
  statistics_table$log_thrombin <- log(statistics_table$thrombin_conc, 10)
  
  last_y_table <- plot_data[plot_data$thrombin_conc == max_x, 2]
  largest_change_y <- last_y_table[[1]]
  
  
  statistics_table$y <- (statistics_table$change_y / largest_change_y)
  #y2 is y/(1-y)
  statistics_table$y2<- (statistics_table$y / (1 - statistics_table$y))
  statistics_table$log_y2 <- log(statistics_table$y2, 10)
  #remove unimportant rows
  subset_statistics_table <- statistics_table[!(statistics_table$thrombin_conc == 0
                                                | statistics_table$y == 1),]
  
  #make example linear fit:
  n_plot <- ggplot(data = subset_statistics_table) +
    geom_point(aes(x = log_thrombin, y = log_y2))
  n_plot
  
  #linear regression
  n_regression <- lm(formula = log_y2 ~ log_thrombin, data = subset_statistics_table)
  n_regression_table <- coef(summary(n_regression))
  
  
  #store n value
  n_value <- n_regression_table[2,1]
  n_error <- n_regression_table[2,2]
  
  
  #set number of points in best fit line
  fit_line_points <- 100
  
  #create simple plot of the data with error bars
  p <- ggplot(data = plot_data) +
    geom_errorbar(aes(x = thrombin_conc,
                      ymax = change_y + SEM,
                      ymin = change_y - SEM), color = "red") +
    geom_point(aes(x = thrombin_conc, y = change_y), size = 3) +
    labs(title = plot_title,
         x = x_axis_label,
         y = y_axis_label) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  
  #show the plot
  #p
  
  
  #Hill equation
  #K is Ka, B is Bmax (Kd is 1/Ka)
  Hill <- change_y ~ (B * (thrombin_conc ^ n_value)) / ((K ^ n_value) + (thrombin_conc ^ n_value))
  
  
  #non linear least squares fit with hill equation, print data
  #automatically starts B and K as 1
  nls_binding_fit <- nls(Hill, plot_data)
  fit_results <- coef(summary(nls_binding_fit))
  
  #show the evaluation of the Hill equation
  print(summary(nls_binding_fit))
  
  #save coefficients as variables (figure out how to get errors from this table as variables)
  B_max <- fit_results[1,1]
  K_a <- fit_results[2,1]
  
  K_a_error <- fit_results[2,2]
  B_max_error <- fit_results[1,2]
  
  #calculate Kd
  K_d <- 1 / K_a
  K_d_error <- 1 / K_a_error #check if this is correct
  
  
  #create fit data frame (make these match the data plot in the future)
  fit_df <- data.frame(x=seq(from = min_x, to = max_x, length.out = fit_line_points))
  fit_df$y <- (B_max * (fit_df$x ^ n_value)) / ((K_a ^ n_value) + (fit_df$x ^ n_value))
  
  
  #make label
  #Bmax_string <- expression(paste(B[`max`], " = "))
  #line_1 <- paste(Bmax_string, round(B_max, 2))
  Bmax_string <- bquote(B[max]~"="~.(round(B_max, dps_bmax))~""%+-%""~.(round(B_max_error, dps_bmax)))
  Ka_string <- bquote(K[a]~"(nM) ="~.(round(K_a, dps_ka))~""%+-%""~.(round(K_a_error, dps_ka)))
  n_string <- bquote("n = "~.(round(n_value, dps_n))~""%+-%""~.(round(n_error, dps_n)))
  
  #Add fit line to plot and show constants (show plot)
  p_fit <- p + geom_line(data = fit_df, aes(x = x, y = y)) +
    annotate("text", x = (max_x - (max_x/4)),
             y = (max_y - (max_y/2)),
             label = Ka_string, size = 7, color = "dark gray") +
    annotate("text", x = (max_x - (max_x/4)),
             y = (max_y - (7/12)*max_y),
             label = n_string, size = 7, color = "dark gray")
  p_fit
  print(paste0("n = ", round(n_value, 4)))
  print(paste0("n uncertainty = ", round(n_error, 4)))
  print(paste0("Ka = ", round(K_a, 4)))
  print(paste0("Ka uncertainty = ", round(K_a_error, 4)))
  print(paste0("Bmax = ", round(B_max, 4)))
  print(paste0("Bmax uncertainty = ", round(B_max_error, 4)))
  
  #return a fit df that can be added to another plot, or return the single plot
  if (return_obj == "plot") {
    return(p_fit)
  }
  else {
    return(fit_df)
  }
  
  
  #turn warnings back on
  options(warn = oldw)
  
}


