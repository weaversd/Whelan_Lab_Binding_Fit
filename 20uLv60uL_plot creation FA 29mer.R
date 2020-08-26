plot_data <- read_excel("20v60ul.xlsx", 
                        sheet = "Import")

Bmax_20 <- bquote(B[max]~"=  0.085 "~""%+-%""~"0.002")
Ka20 <- bquote(K[a]~"=  56 "~""%+-%""~"4 nM")
Bmax_60 <- bquote(B[max]~"=  0.079 "~""%+-%""~"0.002")
Ka60 <- bquote(K[a]~"=  52 "~""%+-%""~"3 nM")


p <- ggplot(data = plot_data) +
  geom_errorbar(aes(x = thrombin_conc,
                    ymax = change_r_20 + SEM_20,
                    ymin = change_r_20 - SEM_20), color = "blue") +
  geom_errorbar(aes(x = thrombin_conc,
                    ymax = change_r_60 + SEM_60,
                    ymin = change_r_60 - SEM_60), color = "red") +
  geom_point(aes(x=thrombin_conc, y=change_r_20), color = "blue", size = 3) +
  geom_point(aes(x=thrombin_conc, y=change_r_60), color = "red", size = 3) +
  geom_line(data=df_20_fit, aes(x=x, y=y), color = "blue") +
  geom_line(data=df_60_fit, aes(x=x, y=y), color = "red") +
  theme_bw() +
  labs(title = "29mer Thrombin FA binding curve: 20uL/well vs 60uL/well",
       y = "Change in Anisotropy",
       x = "Thrombin Conc (nM)") + 
  annotate("text", x = 450, y = 0.05,
           label = "20uL per well", color = "blue", size = 7) + 
  annotate("text", x = 850, y = 0.05,
           label = "60uL per well", color = "red", size = 7) +
  annotate("text", x = 450, y = 0.04,
           label = Bmax_20, color = "blue", size = 5) +
  annotate("text", x = 450, y = 0.045,
           label = Ka20, color = "blue", size = 5) +
  annotate("text", x = 850, y = 0.04,
           label = Bmax_60, color = "red", size = 5) +
  annotate("text", x = 850, y = 0.045,
           label = Ka60, color = "red", size = 5)
  
p

