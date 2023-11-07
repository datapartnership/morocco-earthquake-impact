# Annual Trends in Nighttime Lights

# ADM 0 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "adm0", 
                            paste0("adm0", "_monthly_ntl.Rds")))

ntl_df %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Monthly Nighttime Lights: Country Level") +
  scale_x_date(date_breaks = "12 months", date_labels = "%Y") +  # Set breaks to every 6 months
  theme_classic2()

ggsave(filename = file.path(figures_dir, "monthly_trends_adm0.png"),
       height = 2, width = 4.5)

# ADM 1 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "adm1", 
                            paste0("adm1", "_monthly_ntl.Rds")))

ntl_df %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Monthly Nighttime Lights: ADM 1") +
  scale_x_date(date_breaks = "12 months", date_labels = "%Y") +  # Set breaks to every 6 months
  theme_classic2() +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold")) +
  facet_wrap(~NAME_1,
             scales = "free_y")

ggsave(filename = file.path(figures_dir, "monthly_trends_adm1.png"),
       height = 4, width = 6)
