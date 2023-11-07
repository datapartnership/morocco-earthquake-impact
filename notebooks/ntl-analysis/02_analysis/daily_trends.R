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
       title = "Daily Nighttime Lights: Country Level") +
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
       title = "Daily Nighttime Lights: ADM1 Level") +
  theme_classic2() +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 6)) +
  facet_wrap(~NAME_1,
             scales = "free_y")

ggsave(filename = file.path(figures_dir, "daily_trends_adm1.png"),
       height = 5, width = 10)

# MI Zones ---------------------------------------------------------------------
ntl_indiv_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "mi_indiv", 
                            "mi_indiv_daily_ntl.Rds"))

ntl_3to5_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "mi_3to5", 
                                  "mi_3to5_daily_ntl.Rds")) %>%
  mutate(mi = "MI = 3 to 5")

ntl_4to6_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "mi_4to6", 
                                 "mi_4to6_daily_ntl.Rds")) %>%
  mutate(mi = "MI = 4 to 6")

ntl_7to9_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "mi_7to9", 
                                 "mi_7to9_daily_ntl.Rds")) %>%
  mutate(mi = "MI = 7 to 9")

ntl_range_df <- bind_rows(ntl_3to5_df,
                          ntl_4to6_df,
                          ntl_7to9_df)

THRESH <- ntl_indiv_df$ntl_bm_mean[!is.na(ntl_indiv_df$ntl_bm_mean)] %>% quantile(0.98) %>% as.numeric()
ntl_indiv_df$ntl_bm_mean[ntl_indiv_df$ntl_bm_mean >= THRESH] <- THRESH

ntl_indiv_df %>%
  mutate(mi = paste0("MI = ", mi)) %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  geom_vline(xintercept = ymd("2023-09-08"),
             color = "red") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Daily Nighttime Lights: by Earthquake Intensity",
       subtitle = "Marrakech excluded from analysis",
       caption = "Values winsorized at the 98% level") +
  theme_classic2() +
  facet_wrap(~mi) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 6))

ggsave(filename = file.path(figures_dir, "daily_trends_eq_indiv.png"),
       height = 3, width = 5.5)


THRESH <- ntl_range_df$ntl_bm_mean[!is.na(ntl_range_df$ntl_bm_mean)] %>% quantile(0.98) %>% as.numeric()
ntl_range_df$ntl_bm_mean[ntl_range_df$ntl_bm_mean >= THRESH] <- THRESH

ntl_range_df %>%
  ggplot() +
  geom_col(aes(x = date, 
               y = ntl_bm_mean),
           fill = "gray30") +
  geom_vline(xintercept = ymd("2023-09-08"),
             color = "red") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Daily Nighttime Lights: by Earthquake Intensity",
       subtitle = "Marrakech excluded from analysis",
       caption = "Values winsorized at the 98% level") +
  theme_classic2() +
  facet_wrap(~mi) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold"),
        axis.text.x = element_text(size = 6))

ggsave(filename = file.path(figures_dir, "daily_trends_eq_range.png"),
       height = 2.5, width = 5)
