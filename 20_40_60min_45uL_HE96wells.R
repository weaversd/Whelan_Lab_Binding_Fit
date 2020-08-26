plot_data <- read_excel("20_40_60min_incubation_HE96.xlsx", 
                        sheet = "Import")

Bmax_20 <- bquote(B[max]~"=  0.061 "~""%+-%""~"0.001")
Ka20 <- bquote(K[a]~"=  45 "~""%+-%""~"2 nM")
Bmax_40 <- bquote(B[max]~"=  0.060 "~""%+-%""~"0.001")
Ka40 <- bquote(K[a]~"=  45 "~""%+-%""~"2 nM")
Bmax_60 <- bquote(B[max]~"=  0.061 "~""%+-%""~"0.001")
Ka60 <- bquote(K[a]~"=  49 "~""%+-%""~"2 nM")


p <- ggplot(data = plot_data) +
  geom_errorbar(aes(x = thrombin_conc,
                    ymax = change_r_20 + SEM_20,
                    ymin = change_r_20 - SEM_20), color = "blue") +
  geom_errorbar(aes(x = thrombin_conc,
                    ymax = change_r_40 + SEM_40,
                    ymin = change_r_40 - SEM_40), color = "red") +
  geom_errorbar(aes(x = thrombin_conc,
                    ymax = change_r_60 + SEM_60,
                    ymin = change_r_60 - SEM_60), color = "orange") +
  geom_point(aes(x=thrombin_conc, y=change_r_20), color = "blue", size = 3) +
  geom_point(aes(x=thrombin_conc, y=change_r_40), color = "red", size = 3) +
  geom_point(aes(x=thrombin_conc, y=change_r_60), color = "orange", size = 3) +
  geom_line(data=df_20min_fit, aes(x=x, y=y), color = "blue") +
  geom_line(data=df_40min_fit, aes(x=x, y=y), color = "red") +
  geom_line(data=df_60min_fit, aes(x=x, y=y), color = "orange") +
  theme_bw() +
  labs(title = "29mer Thrombin FA binding curve: HE 96 well plate 20, 40, and 60 minute incubation",
       y = "Change in Anisotropy",
       x = "Thrombin Conc (nM)") + 
  annotate("text", x = 450, y = 0.05,
           label = "20 minute incubation", color = "blue", size = 7) + 
  annotate("text", x = 850, y = 0.05,
           label = "40 minute incubation", color = "red", size = 7) +
  annotate("text", x = 450, y = 0.04,
           label = Bmax_20, color = "blue", size = 5) +
  annotate("text", x = 450, y = 0.045,
           label = Ka20, color = "blue", size = 5) +
  annotate("text", x = 850, y = 0.04,
           label = Bmax_40, color = "red", size = 5) +
  annotate("text", x = 850, y = 0.045,
           label = Ka40, color = "red", size = 5) +
  annotate("text", x = 625, y = 0.03,
           label = "60 minute incubation", color = "orange", size = 7) +
  annotate("text", x = 625, y = 0.02,
           label = Bmax_60, color = "orange", size = 5) +
  annotate("text", x = 625, y = 0.025,
           label = Ka60, color = "orange", size = 5)

p

