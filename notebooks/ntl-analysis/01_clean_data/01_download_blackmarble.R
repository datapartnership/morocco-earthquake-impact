# Download BlackMarble Data

# Setup ------------------------------------------------------------------------
# Load bearer token
bearer <- file.path(ntl_dir, "blackmarble-bearer-token", "bearer_bm.csv") %>%
  read_csv() %>%
  pull("token")

# Load boundaries
roi_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_0.shp"))

# Download data ----------------------------------------------------------------
bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A4",
          date =2012:2023,
          bearer = bearer,
          quality_flag_rm = c(255,1),
          output_location_type = "file",
          file_dir = file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual"))

bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A3",
          date = seq.Date(from = ymd("2012-01-01"), to = Sys.Date(), by = "month"),
          bearer = bearer,
          quality_flag_rm = c(255,1),
          output_location_type = "file",
          file_dir = file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly"))

bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A2",
          date = seq.Date(from = ymd("2023-08-01"), to = Sys.Date(), by = 1) %>% rev(),
          bearer = bearer,
          quality_flag_rm = c(255,2),
          output_location_type = "file",
          file_dir = file.path(ntl_dir, "ntl-rasters", "blackmarble", "daily"))
