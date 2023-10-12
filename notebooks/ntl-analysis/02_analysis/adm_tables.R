# Tables for ADM2 and ADM3

#### Load data
roi_name <- "adm2"
for(roi_name in c("adm2", "adm3")){
  
  ntl_annual_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
                                     paste0(roi_name, "_annual_ntl.Rds")))
  
  ntl_daily_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
                                    paste0(roi_name, "_daily_ntl.Rds")))
  
  eq_df <- read_csv(file.path(data_dir, "earthquake_intensity", 
                              "intensity_mi_by_admin", 
                              paste0(roi_name, ".csv")))
  
  #### Prep name
  if(roi_name == "adm2"){
    
    ntl_2023pre_df <- ntl_daily_df %>%
      dplyr::filter(date <= ymd("2023-09-07")) %>%
      group_by(NAME_1, NAME_2) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(pre_2023 = ntl_bm_mean)
    
    ntl_2023post_df <- ntl_daily_df %>%
      dplyr::filter(date >= ymd("2023-09-09")) %>%
      group_by(NAME_1, NAME_2) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(post_2023 = ntl_bm_mean)

    ntl_14_22_df <- ntl_annual_df %>%
      dplyr::filter(year %in% c(2014, 2022)) %>%
      dplyr::select(year, NAME_1, NAME_2, ntl_bm_mean) %>%
      pivot_wider(names_from = year,
                  values_from = ntl_bm_mean) 
    
    eq_df <- eq_df %>%
      dplyr::select(NAME_1, NAME_2, eq_mi)
    
    ntl_df <- ntl_14_22_df %>%
      left_join(ntl_2023post_df, by = c("NAME_1", "NAME_2")) %>%
      left_join(ntl_2023pre_df, by = c("NAME_1", "NAME_2")) %>%
      left_join(eq_df, by = c("NAME_1", "NAME_2"))
  }
  
  if(roi_name == "adm3"){
    
    ntl_2023post_df <- ntl_daily_df %>%
      dplyr::filter(date >= ymd("2023-09-09")) %>%
      group_by(NAME_1, NAME_2, NAME_3) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(post_2023 = ntl_bm_mean)
    
    ntl_2023pre_df <- ntl_daily_df %>%
      dplyr::filter(date <= ymd("2023-09-07")) %>%
      group_by(NAME_1, NAME_2, NAME_3) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(pre_2023 = ntl_bm_mean)
    
    ntl_14_22_df <- ntl_annual_df %>%
      dplyr::filter(year %in% c(2014, 2022)) %>%
      dplyr::select(year, NAME_1, NAME_2, NAME_3, ntl_bm_mean) %>%
      pivot_wider(names_from = year,
                  values_from = ntl_bm_mean) 
    
    eq_df <- eq_df %>%
      dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi)
    
    ntl_df <- ntl_14_22_df %>%
      left_join(ntl_2023post_df, by = c("NAME_1", "NAME_2", "NAME_3")) %>%
      left_join(ntl_2023pre_df, by = c("NAME_1", "NAME_2", "NAME_3")) %>%
      left_join(eq_df, by = c("NAME_1", "NAME_2", "NAME_3"))
  }
  
  ntl_df$eq_mi[ntl_df$eq_mi == -Inf] <- NA
  #ntl_df$eq_mi[is.na(ntl_df$eq_mi)] <- "< 2.6"
  
  # Export ---------------------------------------------------------------------
  ntl_df <- ntl_df %>%
    dplyr::select(-"2022") %>%
    dplyr::mutate(pc_14_23pre_eq  = (pre_2023 - `2014`) / `2014`,
                  pc_14_23post_eq = (post_2023 - `2014`) / `2014`) %>%
    dplyr::rename(yr2014 = "2014",
                  yr2023_pre_eq = "pre_2023",
                  yr2023_post_eq = "post_2023")
  ntl_df$pc_14_23pre_eq[ntl_df$pc_14_23pre_eq == Inf] <- NA
  ntl_df$pc_14_23post_eq[ntl_df$pc_14_23post_eq == Inf] <- NA
  
  write_csv(ntl_df, file.path(tables_dir,
                              "ntl_adm2_adm3",
                              paste0("ntl_",roi_name,".csv")))
  
  # Make png table -------------------------------------------------------------
  if(roi_name == "adm2"){
    ntl_df %>%
      dplyr::select(NAME_1, NAME_2, eq_mi, yr2014, yr2023_pre_eq, yr2023_post_eq, pc_14_23pre_eq, pc_14_23post_eq) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::mutate(yr2014 = round(yr2014, 2),
                    #yr2022 = round(yr2022, 2),
                    yr2023_pre_eq = round(yr2023_pre_eq, 2),
                    yr2023_post_eq = round(yr2023_post_eq, 2),
                    
                    pc_14_23pre_eq = paste0(round(pc_14_23pre_eq, 2),"%  ."),
                    pc_14_23post_eq = paste0(round(pc_14_23post_eq, 2), "%  .")) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "EQ: MI" = eq_mi,
                    "2014" = yr2014,
                    "2023, Pre Eq." = yr2023_pre_eq,
                    "2023, Post Eq." = yr2023_post_eq,
                    "PC 2014 to 2023, Pre Eq." = pc_14_23pre_eq,
                    "PC 2014 to 2023, Post Eq." = pc_14_23post_eq) %>%
      gt() %>%
      # gt_color_rows(c(`PC: 19 to 22`,
      #                 `PC: 20 to 22`,
      #                 `PC: 21 to 22`), 
      #               palette = "Reds",
      #               reverse = T) %>%
      gtsave(filename = file.path(figures_dir, paste0("eq_table_",roi_name,".png")))
  }
  
  if(roi_name == "adm3"){
    ntl_df %>%
      dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi, yr2014, yr2023_pre_eq, yr2023_post_eq, pc_14_23pre_eq, pc_14_23post_eq) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::mutate(yr2014 = round(yr2014, 2),
                    #yr2022 = round(yr2022, 2),
                    yr2023_pre_eq = round(yr2023_pre_eq, 2),
                    yr2023_post_eq = round(yr2023_post_eq, 2),
                    
                    pc_14_23pre_eq = paste0(round(pc_14_23pre_eq, 2),"%  ."),
                    pc_14_23post_eq = paste0(round(pc_14_23post_eq, 2), "%  .")) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "ADM 3" = NAME_3,
                    "EQ: MI" = eq_mi,
                    "2014" = yr2014,
                    "2023, Pre Eq." = yr2023_pre_eq,
                    "2023, Post Eq." = yr2023_post_eq,
                    "PC 2014 to 2023, Pre Eq." = pc_14_23pre_eq,
                    "PC 2014 to 2023, Post Eq." = pc_14_23post_eq) %>%
      gt() %>%
      # gt_color_rows(c(`PC: 19 to 22`,
      #                 `PC: 20 to 22`,
      #                 `PC: 21 to 22`), 
      #               palette = "Reds",
      #               reverse = T) %>%
      gtsave(filename = file.path(figures_dir, 
                                  paste0("eq_table_",roi_name,".png")))
  }
}







