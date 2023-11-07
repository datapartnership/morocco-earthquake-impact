# Percent Change Maps

mi_sf <- read_sf(file.path(data_dir, "earthquake_intensity", "shape", "mi.shp"))

mi_strong_sf <- mi_sf[mi_sf$PARAMVALUE >= 7,]
mi_strong_sf <- mi_strong_sf %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

for(roi_name in c("adm1", "adm2", "adm3", "adm4")){
  
  # Load data --------------------------------------------------------------------
  ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
                              paste0(roi_name, "_annual_ntl.Rds")))

  # Load ROI ---------------------------------------------------------------------
  if(roi_name == "adm0"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_0.shp"))
  } 
  
  if(roi_name == "adm1"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_1.shp"))
  } 
  
  if(roi_name == "adm2"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_2.shp"))
  } 
  
  if(roi_name == "adm3"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_3.shp"))
  } 
  
  if(roi_name == "adm4"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_4.shp"))
  } 
  
  roi_sf$adm_id <- 1:nrow(roi_sf)
  
  # Prep data -------------------------------------------------------------------
  ntl_pc_df <- ntl_df %>%
    dplyr::filter(year %in% c(2019, 2020, 2021, 2022)) %>%
    dplyr::select(year, adm_id, ntl_bm_mean) %>%
    mutate(year = paste0("yr", year)) %>%
    pivot_wider(id_cols = adm_id, names_from = year, values_from = "ntl_bm_mean") %>%
    mutate(pc19 = (yr2022 - yr2019) / yr2019 * 100,
           pc20 = (yr2022 - yr2020) / yr2020 * 100,
           pc21 = (yr2022 - yr2021) / yr2021 * 100)
  
  roi_sf <- roi_sf %>%
    left_join(ntl_pc_df, by = "adm_id")
  
  roi_sf$pc19[roi_sf$pc19 >= 200] <- 200
  roi_sf$pc20[roi_sf$pc20 >= 200] <- 200
  roi_sf$pc21[roi_sf$pc21 >= 200] <- 200
  
  # Map --------------------------------------------------------------------------
  city_df <- data.frame(lat = 31.63, lon = -8.008889, name = "Marrakesh")
  
  roi_long_sf <- roi_sf %>%
    dplyr::select(adm_id, pc19, pc20, pc21) %>%
    pivot_longer(cols = -c(adm_id, geometry)) %>%
    dplyr::mutate(name_clean = case_when(
      name == "pc19" ~ "2019 to 2022",
      name == "pc20" ~ "2020 to 2022",
      name == "pc21" ~ "2021 to 2022"
    )) 
  
  p <- ggplot() +
    geom_sf(data = roi_long_sf,
            aes(fill = value,
                color = value)) +
    geom_sf(data = mi_strong_sf,
            fill = NA,
            color = "black",
            linewidth = 0.2) + 
    labs(fill = "% Change\nin NTL",
         color = "% Change\nin NTL",
         caption = "Black boundary indicates earthquake magnitude of 7 and above") +
    coord_sf() +
    theme_void() +
    scale_fill_gradient2(low = "red", high = "forestgreen", mid = "white") +
    scale_color_gradient2(low = "red", high = "forestgreen", mid = "white") +
    
    #scale_fill_distiller(palette = "YlOrRd", direction = -1) +
    #scale_color_distiller(palette = "YlOrRd", direction = -1) +
    facet_wrap(~name_clean) +
    geom_point(data = city_df,
               aes(x = lon, y = lat)) +
    geom_text_repel(data = city_df,
                    aes(x = lon, y = lat, label = name),
                    seed = 9900,
                    nudge_y = 2,
                    nudge_x = -5000) 
  
  ggsave(p,
         filename = file.path(figures_dir, paste0("pc_map_",roi_name,".png")),
         height = 5, width = 8)
  
  # Table ----------------------------------------------------------------------
  if(roi_name == "adm1") roi_sf <- roi_sf %>% dplyr::mutate(name = NAME_1)
  if(roi_name == "adm2") roi_sf <- roi_sf %>% dplyr::mutate(name = NAME_2)
  if(roi_name == "adm3") roi_sf <- roi_sf %>% dplyr::mutate(name = NAME_3)
  if(roi_name == "adm4") roi_sf <- roi_sf %>% dplyr::mutate(name = NAME_4)
  
  #roi_sf$name[roi_sf$name == "Trablous El-Haddadine, El-Hadid, El-Mharta"] <- "Trablous El-Haddadine"
  
  roi_sf %>%
    st_drop_geometry() %>%
    dplyr::select(name, yr2019, yr2020, yr2021, yr2022, pc19, pc20, pc21) %>%
    #dplyr::filter(pc < 0) %>%
    arrange(-yr2019) %>%
    head(30) %>%
    dplyr::mutate(yr2019 = round(yr2019, 2),
                  yr2020 = round(yr2020, 2),
                  yr2021 = round(yr2021, 2),
                  yr2022 = round(yr2022, 2),
                  pc19 = round(pc19,1),
                  pc20 = round(pc20,1),
                  pc21 = round(pc21,1)) %>%
    dplyr::rename("Name" = name,
                  "NTL: 2019" = yr2019,
                  "NTL: 2020" = yr2020,
                  "NTL: 2021" = yr2021,
                  "NTL: 2022" = yr2022,
                  "PC: 19 to 22" = pc19,
                  "PC: 20 to 22" = pc20,
                  "PC: 21 to 22" = pc21) %>%
    gt() %>%
    #gt_hulk_col_numeric(`NTL: 2019`, trim = TRUE) %>%
    #gt_hulk_col_numeric(`NTL: 2022`, trim = TRUE)  %>%
    gt_color_rows(c(`PC: 19 to 22`,
                    `PC: 20 to 22`,
                    `PC: 21 to 22`), 
                  palette = "Reds",
                  reverse = T) %>%
    gtsave(filename = file.path(figures_dir, paste0("pc_table_",roi_name,".png")))
  
}
