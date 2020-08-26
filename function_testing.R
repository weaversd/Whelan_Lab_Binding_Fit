bind_curve_thrombin("APCE_data_8_12_2020.xlsx", dps = 2)
bind_curve_thrombin("APCE_Height.xlsx")
bind_curve_thrombin("APCE_Area.xlsx")

bind_curve_sqrhyp("APCE_data_8_12_2020.xlsx", dps = 3)

bind_curve_thrombin("APCE_Height.xlsx")
bind_curve_thrombin("APCE_Height 2.xlsx")

bind_curve_thrombin("APCE_Area.xlsx")
bind_curve_thrombin("APCE_Area 2.xlsx")

bind_curve_thrombin("APCE_CorArea 2.xlsx")

bind_curve_thrombin("APCE_Height 2.xlsx", title = "Binding Curve based on Peak Height", dps = 2)
bind_curve_thrombin("APCE_Area 2.xlsx", title = "Binding Curve based on Peak Area", dps = 2)
bind_curve_thrombin("APCE_CorArea 2.xlsx", title = "Binding Curve based on MT Corrected Peak Area", dps =2)

bind_curve_thrombin("20uL_FA_Aptamer_Thrombin.xlsx", y_ax = "Change in Anisotropy",
                    title = "Binding Curve, 29mer Aptamer (75nM) with Thrombin, 20 uL per well")

bind_curve_thrombin("60uL_FA_Aptamer_Thrombin.xlsx", y_ax = "Change in Anisotropy",
                    title = "Binding Curve, 29mer Aptamer (75nM) with Thrombin, 60 uL per well")
p_fit

df_20_fit <- bind_curve_thrombin("20uL_FA_Aptamer_Thrombin.xlsx", y_ax = "Change in Anisotropy",
                                 title = "Binding Curve, 29mer Aptamer (75nM) with Thrombin, 20 uL per well")
df_60_fit <-bind_curve_thrombin("60uL_FA_Aptamer_Thrombin.xlsx", y_ax = "Change in Anisotropy",
                                title = "Binding Curve, 29mer Aptamer (75nM) with Thrombin, 60 uL per well")


bind_curve_thrombin("20min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
bind_curve_thrombin("40min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
bind_curve_thrombin("60min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")

df_20min_fit <- bind_curve_thrombin("20min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
df_40min_fit <- bind_curve_thrombin("40min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
df_60min_fit <- bind_curve_thrombin("60min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")


df_20min_plot <- bind_curve_thrombin("20min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
df_40min_plot <- bind_curve_thrombin("40min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
df_60min_plot <- bind_curve_thrombin("60min_HE96well_plate08242020_45uL.xlsx", y_ax = "Change in Anisotropy")
