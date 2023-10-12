# Extract Nighttime Lights to Polygons

# Loop through different polygon types. For each polygon type
# 1. Make directories for where to save data
# 2. Aggregate annual data, both 
# -- (a) VIIRS Black Marble [2012 - 2022]
# -- (b) DMSP [1992 - 2013]
# -- (c) Simulated DMSP (from VIIRS) [2014 - 2021]
# 3. Aggregate monthly data, VIIRS Black Marble only [2012 - present]

OUT_PATH <- file.path(data_dir, "earthquake_intensity", "sepate_files_by_intensity")

for(roi_name in c("adm0", "adm1", "adm2", "adm3", "adm4", 
                  "mi_indiv",
                  "mi_3to5", "mi_4to6", "mi_7to9")){
  
  # Make Directories -------------------------------------------------------------
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name))
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-daily"))
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly"))
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual"))
  
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
  
  if(str_detect(roi_name, "mi")){
    roi_sf <- read_sf(file.path(data_dir, "earthquake_intensity", "separate_files_by_intensity", 
                                paste0(roi_name, ".geojson")))
  }
  
  roi_sf$adm_id <- 1:nrow(roi_sf)
  
  # Aggregate annual -------------------------------------------------------------
  for(year in 2012:2022){
    
    ## Only process if file already hasn't been created
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual", paste0("ntl_", year, ".Rds"))
    
    if(!file.exists(OUT_FILE)){
      
      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_t",year,".tif")))
      
      roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_bm_q50     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.5)
      roi_sf$ntl_bm_q60     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.6)
      roi_sf$ntl_bm_q70     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.7)
      roi_sf$ntl_bm_q80     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.8)
      roi_sf$ntl_bm_q90     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.9)
      roi_sf$ntl_bm_q95     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.95)
      roi_sf$ntl_bm_q99     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.99)
      
      roi_sf$year <- year
      
      roi_df <- roi_sf
      roi_df$geometry <- NULL
      
      saveRDS(roi_df, OUT_FILE)
    }
    
  }
  
  #### Append all data
  ntl_annual_df <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual") %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)
  
  #ntl_annual_df$ntl_bm_mean[ntl_annual_df$ntl_bm_mean < 0] <- 0
  
  saveRDS(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.Rds")))
  write_csv(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.csv")))
  
  # Aggregate monthly ------------------------------------------------------------
  monthly_rasters <- file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly") %>%
    list.files(pattern = "*.tif")
  
  for(r_month_i in monthly_rasters){
    
    ## Only process if file already hasn't been created
    month_i <- r_month_i %>%
      str_replace_all(".*_t", "") %>%
      str_replace_all(".tif", "")
    
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly", paste0("ntl_", month_i, ".Rds"))
    
    if(!file.exists(OUT_FILE)){
      
      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly", r_month_i))
      
      roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_bm_q50     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.5)
      roi_sf$ntl_bm_q60     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.6)
      roi_sf$ntl_bm_q70     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.7)
      roi_sf$ntl_bm_q80     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.8)
      roi_sf$ntl_bm_q90     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.9)
      roi_sf$ntl_bm_q95     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.95)
      roi_sf$ntl_bm_q99     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.99)
      
      roi_sf$date <- month_i %>%
        str_replace_all("_", "-") %>%
        paste0("-01") %>% 
        ymd()
      
      roi_df <- roi_sf
      roi_df$geometry <- NULL
      
      saveRDS(roi_df, OUT_FILE)
    }
  }
  
  ntl_monthly_df <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly") %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)
  
  saveRDS(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.Rds")))
  write_csv(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.csv")))
  
  # Aggregate daily ------------------------------------------------------------
  daily_rasters <- file.path(ntl_dir, "ntl-rasters", "blackmarble", "daily") %>%
    list.files(pattern = "*.tif")
  
  for(r_day_i in daily_rasters){
    
    ## Only process if file already hasn't been created
    day_i <- r_day_i %>%
      str_replace_all(".*_t", "") %>%
      str_replace_all(".tif", "")
    
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-daily", paste0("ntl_", day_i, ".Rds"))
    
    if(!file.exists(OUT_FILE)){
      
      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "daily", r_day_i))
      
      roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_bm_q50     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.5)
      roi_sf$ntl_bm_q60     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.6)
      roi_sf$ntl_bm_q70     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.7)
      roi_sf$ntl_bm_q80     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.8)
      roi_sf$ntl_bm_q90     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.9)
      roi_sf$ntl_bm_q95     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.95)
      roi_sf$ntl_bm_q99     <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = 0.99)
      
      roi_sf$date <- day_i %>%
        str_replace_all("_", "-") %>%
        ymd()
      
      roi_df <- roi_sf
      roi_df$geometry <- NULL
      
      saveRDS(roi_df, OUT_FILE)
    }
  }
  
  ntl_daily_df <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-daily") %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)
  
  saveRDS(ntl_daily_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_daily_ntl.Rds")))
  write_csv(ntl_daily_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_daily_ntl.csv")))
  
}


