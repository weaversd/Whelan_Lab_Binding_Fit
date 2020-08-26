###a function that provides a binding curve give excel data file input, and produces
#a plot of the binding curve, as well as the calculated Bmax and Ka values.
###by default used Hill equation for thrombin model. Other equations will be built in later
###Automatically supplies 1 as starting points for all variables in non linear least squares regression
###tables must not have na values
###file must be .xlsx and have a sheet titled "Import" with three columns of data:
  ###1st column: concentration of protein
  ###2nd column: change in y values (I0-I)/I0
  ###3rd column: standard error of the mean for change in y.
###function arguments:
  ###file = location of .xlsx file (~required~)
  ###title = graph title (default "Binding Curve)
  ###x_ax = x axis label (default Thrombin Concentration (nM))
  ###y_ax = y axis label (default "(I0-I)/I0")
  ###dps = number of decimal places (default 3)



bind_curve_thrombin <- function(file, title = "Binding Curve",
                                dps = 3,
                                x_ax = "Thrombin Concentration (nM)",
                                y_ax = bquote("("~I[0]-I~") /"~I[0]~"")) {
  
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
  #thrombin_conc is in nM, change_y is ((Io-I)/Io), SEM is std error on the mean
  plot_data <- read_excel(file, 
                          sheet = "Import")
  
  #rename columns
  colnames(plot_data) <- c("thrombin_conc", "change_y", "SEM")
  
  #Calculate the n value:
  #copy plot data
  statistics_table <- plot_data
  
  print(statistics_table)
  
  #find min and max x and y values
  max_x <- max(plot_data$thrombin_conc)
  min_x <- min(plot_data$thrombin_conc)
  max_y <- max(plot_data$change_y)
  min_y <- min(plot_data$change_y)
  
  #calculate columns
  statistics_table$log_thrombin <- log(statistics_table$thrombin_conc, 10)
  
  last_y_table <- plot_data[plot_data$thrombin_conc == max_x, 2]
  largest_change_y <- last_y_table[[1]]
  print(last_y_table)
  print(largest_change_y)
  
  
  statistics_table$y <- (statistics_table$change_y / largest_change_y)
  #y2 is y/(1-y)
  statistics_table$y2<- (statistics_table$y / (1 - statistics_table$y))
  statistics_table$log_y2 <- log(statistics_table$y2, 10)
  #remove unimportant rows
  subset_statistics_table <- statistics_table[!(statistics_table$thrombin_conc == 0
                                                | statistics_table$y == 1),]
  
  
  print(statistics_table)
  #make example linear fit:
  n_plot <- ggplot(data = subset_statistics_table) +
    geom_point(aes(x = log_thrombin, y = log_y2))
  n_plot
  
  #linear regression
  n_regression <- lm(formula = log_y2 ~ log_thrombin, data = subset_statistics_table)
  n_regression_table <- coef(summary(n_regression))
  
  #store n value
  n_value <- n_regression_table[2,1]
  
  
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
  p
  
  
  #Hill equation
  #K is Ka, B is Bmax (Kd is 1/Ka)
  Hill <- change_y ~ (B * (thrombin_conc ^ n_value)) / ((K ^ n_value) + (thrombin_conc ^ n_value))
  
  
  #non linear least squares fit with hill equation, print data
  #automatically starts B and K as 1
  nls_binding_fit <- nls(Hill, plot_data)
  fit_results <- coef(summary(nls_binding_fit))
  print(fit_results)
  
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
  Bmax_string <- bquote(B[max]~"="~.(round(B_max, dps))~""%+-%""~.(round(B_max_error, dps)))
  Ka_string <- bquote(K[a]~"="~.(round(K_a, dps))~""%+-%""~.(round(K_a_error, dps)))
  
  
  #Add fit line to plot and show constants (show plot)
  p_fit <- p + geom_line(data = fit_df, aes(x = x, y = y)) +
    annotate("text", x = (max_x - (max_x/4)),
             y = (max_y - (max_y/2)),
             label = Bmax_string, size = 7, color = "dark gray") +
    annotate("text", x = (max_x - (max_x/4)),
             y = (max_y - (7/12)*max_y),
             label = Ka_string, size = 7, color = "dark gray")
  p_fit
  print(paste0("n = ", round(n_value, 4)))
  return(fit_df)
  
  
  #turn warnings back on
  options(warn = oldw)
  
}
