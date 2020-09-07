# Hill Equation Fit Binding data
Simon Weaver
Whelan Lab - University of Notre Dame
Fall 2020


An R Function that takes binding data and fits it to the Hill equation. For reference: 

  Mears, K.; Markus, D.; Ogunjimi, O.; Whelan, R.
  Experimental and mathematical evidence that thrombin-binding aptamers form a 1 aptamer:2 protein complex.
  Aptatmers 2018, 2, 64-73.


From comments in the function:

###a function that provides a binding curve using the Hill Equation give excel data file input, and produces a plot of the binding curve, as well as the calculated Bmax, n, and Ka values and associated standard error due to the calibration.

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

#example:

bind_curve_Hill("file.xlsx", dps_ka = 1, title = "Hill Function fit for Thrombin and 29mer",
                   return_obj = "fit_df")
