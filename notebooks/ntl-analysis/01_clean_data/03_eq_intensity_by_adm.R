# Earthquake Intensity within ADMs

for(roi_name in c("adm0", "adm1", "adm2", "adm3", "adm4")){
  
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
  
  # Match with Earthquake ------------------------------------------------------
  mi_sf <- read_sf(file.path(data_dir, "earthquake_intensity", "shape", "mi.shp"))
  
  roi_sf$eq_mi <- lapply(1:nrow(roi_sf), function(i){
    print(i)
    roi_sf_i <- roi_sf[i,]
    inter_tf <- st_intersects(roi_sf_i, mi_sf, sparse=F) %>% as.vector()
    mi_sf$PARAMVALUE[inter_tf] %>% max()
  }) %>% 
    unlist()
  
  roi_sf$eq_mi[roi_sf$eq_mi == -Inf] <- NA
  
  # Export ---------------------------------------------------------------------
  roi_df <- roi_sf %>%
    st_drop_geometry()
  
  write_csv(roi_df, file.path(data_dir, "earthquake_intensity", 
                              "intensity_mi_by_admin", 
                              paste0(roi_name, ".csv")))
  
  
  
}





