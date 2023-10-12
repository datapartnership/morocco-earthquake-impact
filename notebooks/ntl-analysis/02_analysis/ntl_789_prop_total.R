# NTL in 789, as proportion of total

# Load data --------------------------------------------------------------------
mor_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_0.shp"))

mi_sf <- read_sf(file.path(data_dir, "earthquake_intensity", "shape", "mi.shp"))
mi_strong_sf <- mi_sf[mi_sf$PARAMVALUE >= 7,]
mi_strong_sf <- mi_strong_sf %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", "VNP46A4_t2022.tif"))

ntl_mor <- exact_extract(r, mor_sf, "sum")
ntl_789 <- exact_extract(r, mi_strong_sf, "sum")

ntl_mor
ntl_789

ntl_789 / ntl_mor

