# Prep MI Files

# Load data --------------------------------------------------------------------
mi_sf <- read_sf(file.path(data_dir, "earthquake_intensity", "shape", "mi.shp"))

country0_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_0.shp"))
country2_sf <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_2.shp"))
mrk_sf <- country2_sf[country2_sf$NAME_2 %in% "Marrakech",]

# Subset -----------------------------------------------------------------------
mi_strong_3_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 3,
                PARAMVALUE < 4) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_4_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 4,
                PARAMVALUE < 5) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_5_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 5,
                PARAMVALUE < 6) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_6_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 6,
                PARAMVALUE < 7) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_7_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 7,
                PARAMVALUE < 8) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_8_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 8,
                PARAMVALUE < 9) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_3to5_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 3,
                PARAMVALUE < 6) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_4to6_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 4,
                PARAMVALUE < 7) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

mi_strong_7to9_sf <- mi_sf %>%
  dplyr::filter(PARAMVALUE >= 7,
                PARAMVALUE < 9) %>%
  mutate(id = 1) %>%
  group_by(id) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

# Remove Marrekesh -------------------------------------------------------------
mi_strong_3_sf <- st_intersection(mi_strong_3_sf, country0_sf)
mi_strong_4_sf <- st_intersection(mi_strong_4_sf, country0_sf)
mi_strong_5_sf <- st_intersection(mi_strong_5_sf, country0_sf)
mi_strong_6_sf <- st_intersection(mi_strong_6_sf, country0_sf)
mi_strong_7_sf <- st_intersection(mi_strong_7_sf, country0_sf)
mi_strong_8_sf <- st_intersection(mi_strong_8_sf, country0_sf)
mi_strong_3to5_sf <- st_intersection(mi_strong_3to5_sf, country0_sf)
mi_strong_4to6_sf <- st_intersection(mi_strong_4to6_sf, country0_sf)
mi_strong_7to9_sf <- st_intersection(mi_strong_7to9_sf, country0_sf)

if(st_intersects(mi_strong_3_sf, mrk_sf, sparse = F)[1]){
  mi_strong_3_sf <- st_difference(mi_strong_3_sf, mrk_sf)
}

if(st_intersects(mi_strong_4_sf, mrk_sf, sparse = F)[1]){
  mi_strong_4_sf <- st_difference(mi_strong_4_sf, mrk_sf)
}

if(st_intersects(mi_strong_5_sf, mrk_sf, sparse = F)[1]){
  mi_strong_5_sf <- st_difference(mi_strong_5_sf, mrk_sf)
}

if(st_intersects(mi_strong_6_sf, mrk_sf, sparse = F)[1]){
  mi_strong_6_sf <- st_difference(mi_strong_6_sf, mrk_sf)
}

if(st_intersects(mi_strong_7_sf, mrk_sf, sparse = F)[1]){
  mi_strong_7_sf <- st_difference(mi_strong_7_sf, mrk_sf)
}

if(st_intersects(mi_strong_8_sf, mrk_sf, sparse = F)[1]){
  mi_strong_8_sf <- st_difference(mi_strong_8_sf, mrk_sf)
}

if(st_intersects(mi_strong_3to5_sf, mrk_sf, sparse = F)[1]){
  mi_strong_3to5_sf <- st_difference(mi_strong_3to5_sf, mrk_sf)
}

if(st_intersects(mi_strong_4to6_sf, mrk_sf, sparse = F)[1]){
  mi_strong_4to6_sf <- st_difference(mi_strong_4to6_sf, mrk_sf)
}

if(st_intersects(mi_strong_7to9_sf, mrk_sf, sparse = F)[1]){
  mi_strong_7to9_sf <- st_difference(mi_strong_7to9_sf, mrk_sf)
}

# Export -----------------------------------------------------------------------
OUT_PATH <- file.path(data_dir, "earthquake_intensity", "separate_files_by_intensity")

mi_indv_sf <- bind_rows(
  mi_strong_3_sf %>% mutate(mi = 3),
  mi_strong_4_sf %>% mutate(mi = 4),
  mi_strong_5_sf %>% mutate(mi = 5),
  mi_strong_6_sf %>% mutate(mi = 6),
  mi_strong_7_sf %>% mutate(mi = 7),
  mi_strong_8_sf %>% mutate(mi = 8)
)

write_sf(mi_indv_sf, file.path(OUT_PATH, "mi_indiv.geojson"), delete_dsn = T)

write_sf(mi_strong_3to5_sf, file.path(OUT_PATH, "mi_3to5.geojson"), delete_dsn = T)
write_sf(mi_strong_4to6_sf, file.path(OUT_PATH, "mi_4to6.geojson"), delete_dsn = T)
write_sf(mi_strong_7to9_sf, file.path(OUT_PATH, "mi_7to9.geojson"), delete_dsn = T)






