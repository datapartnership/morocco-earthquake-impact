# Tables for ADM2 and ADM3

#### Load data
roi_name <- "adm2"
for(roi_name in c("adm2", "adm3")){
  
  # ntl_annual_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
  #                                    paste0(roi_name, "_annual_ntl.Rds")))
  # 
  ntl_daily_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
                                    paste0(roi_name, "_daily_ntl.Rds")))
  
  eq_df <- read_csv(file.path(data_dir, "earthquake_intensity", 
                              "intensity_mi_by_admin", 
                              paste0(roi_name, ".csv")))
  
  
  #### Prep data
  if(roi_name == "adm2") ntl_daily_df$NAME_3 <- ""
  if(roi_name == "adm2") eq_df$NAME_3        <- ""
  
  eq_df <- eq_df %>%
    dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi)
  
  ntl_week_df <- ntl_daily_df %>%
    dplyr::mutate(weeks_since_eq = difftime(date, 
                                            ymd("2023-09-08"),
                                            unit = "weeks") %>%
                    as.numeric() %>%
                    floor()) %>%
    group_by(NAME_1, NAME_2, NAME_3, weeks_since_eq) %>%
    dplyr::summarise(ntl_bm_mean = mean(ntl_bm_mean, na.rm = T)) %>%
    ungroup() %>%
    dplyr::mutate(weeks_since_eq = weeks_since_eq %>%
                    as.character() %>%
                    str_replace_all("-", "_")) %>%
    dplyr::mutate(weeks_since_eq = paste0("wk", weeks_since_eq)) %>%
    
    group_by(NAME_1, NAME_2, NAME_3) %>%
    dplyr::mutate(ntl_base = ntl_bm_mean[weeks_since_eq %in% "wk_1"]) %>%
    ungroup() %>%
    
    dplyr::mutate(ntl_pc = (ntl_bm_mean - ntl_base)/ntl_base * 100) %>%
    dplyr::mutate(ntl_pc = round(ntl_pc, 1) %>% paste0("%")) %>%
    
    dplyr::filter(weeks_since_eq != "wk_1") %>%
    pivot_wider(id_cols = c(NAME_1, NAME_2, NAME_3),
                names_from = weeks_since_eq,
                values_from = ntl_pc)
  
  ntl_week_df <- ntl_week_df %>%
    left_join(eq_df, by = c("NAME_1", "NAME_2", "NAME_3")) %>%
    arrange(-eq_mi)
  
  # Make png table -------------------------------------------------------------
  if(roi_name == "adm2"){
    
    ntl_week_df %>%
      dplyr::select(NAME_1, NAME_2, eq_mi, wk_3, wk_2, wk0, wk1, wk2, wk3, wk4) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "EQ: MI" = eq_mi,
                    "-3 Wks" = "wk_3",
                    "-2 Wks" = "wk_2",
                    "0 Wks" = "wk0",
                    "1 Wks" = "wk1",
                    "2 Wks" = "wk2",
                    "3 Wks" = "wk3",
                    "4 Wks" = "wk4") %>%
      gt() %>%
      gtsave(filename = file.path(figures_dir, paste0("eq_table_weeks_",roi_name,".png")))
  }
  
  if(roi_name == "adm3"){
    ntl_week_df %>%
      dplyr::select(NAME_1, NAME_2, NAME_3, eq_mi, wk_3, wk_2, wk0, wk1, wk2, wk3, wk4) %>%
      arrange(-eq_mi) %>%
      head(30) %>%
      dplyr::rename("ADM 1" = NAME_1,
                    "ADM 2" = NAME_2,
                    "ADM 3" = NAME_3,
                    "EQ: MI" = eq_mi,
                    "-3 Wks" = "wk_3",
                    "-2 Wks" = "wk_2",
                    "0 Wks" = "wk0",
                    "1 Wks" = "wk1",
                    "2 Wks" = "wk2",
                    "3 Wks" = "wk3",
                    "4 Wks" = "wk4") %>%
      gt() %>%
      gtsave(filename = file.path(figures_dir, paste0("eq_table_weeks_",roi_name,".png")))
  }
}







