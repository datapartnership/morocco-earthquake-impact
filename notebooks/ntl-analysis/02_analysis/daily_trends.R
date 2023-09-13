# Annual Trends in Nighttime Lights

# ADM 0 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "adm0", 
                            paste0("adm0", "_daily_ntl.Rds")))

ntl_df %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  geom_vline(xintercept = ymd("2023-09-08"),
             color = "red") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: Country Level") +
  theme_classic2()

ggsave(filename = file.path(figures_dir, "daily_trends_adm0.png"),
       height = 2, width = 4.5)

# ADM 1 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "adm1", 
                            paste0("adm1", "_daily_ntl.Rds")))

ntl_df %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  geom_vline(xintercept = ymd("2023-09-08"),
             color = "red") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: ADM1 Level") +
  theme_classic2() +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 6)) +
  facet_wrap(~NAME_1,
             scales = "free_y")

ggsave(filename = file.path(figures_dir, "daily_trends_adm1.png"),
       height = 4, width = 8)
