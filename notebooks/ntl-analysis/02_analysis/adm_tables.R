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
    
    ntl_2023_df <- ntl_daily_df %>%
      dplyr::filter(date >= ymd("2023-09-09")) %>%
      group_by(NAME_1, NAME_2) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(`2023` = ntl_bm_mean)
    
    ntl_14_22_df <- ntl_annual_df %>%
      dplyr::filter(year %in% c(2014, 2022)) %>%
      dplyr::select(year, NAME_1, NAME_2, ntl_bm_mean) %>%
      pivot_wider(names_from = year,
                  values_from = ntl_bm_mean) 
    
    eq_df <- eq_df %>%
      dplyr::select(NAME_1, NAME_2, eq_mi)
    
    ntl_df <- ntl_14_22_df %>%
      left_join(ntl_2023_df, by = c("NAME_1", "NAME_2")) %>%
      left_join(eq_df, by = c("NAME_1", "NAME_2"))
  }
  
  if(roi_name == "adm3"){
    
    ntl_2023_df <- ntl_daily_df %>%
      dplyr::filter(date >= ymd("2023-08-09")) %>%
      group_by(NAME_1, NAME_2, NAME_3) %>%
      dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
      ungroup() %>%
      dplyr::rename(`2023` = ntl_bm_mean)
    
    ntl_14_22_df <- ntl_annual_df %>%
      dplyr::filter(year %in% c(2014, 2022)) %>%
      dplyr::select(year, NAME_1, NAME_2, NAME_3, ntl_bm_mean) %>%
      pivot_wider(names_from = year,
                  values_from = ntl_bm_mean) 
    
    eq_df <- eq_df %>%
      dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi)
    
    ntl_df <- ntl_14_22_df %>%
      left_join(ntl_2023_df, by = c("NAME_1", "NAME_2", "NAME_3")) %>%
      left_join(eq_df, by = c("NAME_1", "NAME_2", "NAME_3"))
  }
  
  ntl_df$eq_mi[ntl_df$eq_mi == -Inf] <- NA
  #ntl_df$eq_mi[is.na(ntl_df$eq_mi)] <- "< 2.6"
  
  # Export ---------------------------------------------------------------------
  ntl_df <- ntl_df %>%
    dplyr::rename(yr2014 = "2014",
                  yr2022 = "2022",
                  yr2023 = "2023")
  
  write_csv(ntl_df, file.path(tables_dir,
                              paste0("ntl_",roi_name,".csv")))
  
  # Make png table -------------------------------------------------------------
  if(roi_name == "adm2"){
    ntl_df %>%
      dplyr::select(NAME_1, NAME_2, eq_mi, yr2014, yr2022, yr2023) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::mutate(yr2014 = round(yr2014, 2),
                    yr2022 = round(yr2022, 2),
                    yr2023 = round(yr2023, 2)) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "EQ: MI" = eq_mi,
                    "NTL: 2014" = yr2014,
                    "NTL: 2022" = yr2022,
                    "NTL: 2023" = yr2023) %>%
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
      dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi, yr2014, yr2022, yr2023) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::mutate(yr2014 = round(yr2014, 2),
                    yr2022 = round(yr2022, 2),
                    yr2023 = round(yr2023, 2)) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "ADM 3" = NAME_3,
                    "EQ: MI" = eq_mi,
                    "NTL: 2014" = yr2014,
                    "NTL: 2022" = yr2022,
                    "NTL: 2023" = yr2023) %>%
      gt() %>%
      # gt_color_rows(c(`PC: 19 to 22`,
      #                 `PC: 20 to 22`,
      #                 `PC: 21 to 22`), 
      #               palette = "Reds",
      #               reverse = T) %>%
      gtsave(filename = file.path(figures_dir, paste0("eq_table_",roi_name,".png")))
  }
}







