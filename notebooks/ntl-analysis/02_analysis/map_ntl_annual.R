# Nighttime Lights Map: 2022

# Load data --------------------------------------------------------------------
r_mean_12  <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_t",2012,".tif")))
r_mean_17  <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_t",2017,".tif")))
r_mean_22  <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_t",2022,".tif")))

roi_sp <- read_sf(file.path(admin_bnd_dir, "gadm41_MAR_shp", "gadm41_MAR_0.shp")) %>%
  as("Spatial")

# Prep data --------------------------------------------------------------------
prep_ntl_df <- function(r_mean){
  r_mean <- r_mean %>% crop(roi_sp) %>% mask(roi_sp) 
  
  r_mean_df <- rasterToPoints(r_mean, spatial = TRUE) %>% as.data.frame()
  names(r_mean_df) <- c("value", "x", "y")
  
  ## Transform NTL
  r_mean_df$value_adj <- log(r_mean_df$value+1)
  
  r_mean_df$value_adj[r_mean_df$value_adj <= 0.5] <- 0
  
  return(r_mean_df)
}

r_mean_df <- bind_rows(
  prep_ntl_df(r_mean_12) %>% mutate(Year = "2012"),
  prep_ntl_df(r_mean_17) %>% mutate(Year = "2017"),
  prep_ntl_df(r_mean_22) %>% mutate(Year = "2022")
)

# Map --------------------------------------------------------------------------
p <- ggplot() +
  geom_raster(data = r_mean_df, 
              aes(x = x, y = y, 
                  fill = value_adj)) +
  scale_fill_gradient2(low = "black",
                       mid = "yellow",
                       high = "red",
                       midpoint = 4.5) +
  labs(title = "Annual Nighttime Lights") +
  coord_quickmap() + 
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        strip.text = element_text(size = 12),
        legend.position = "none") +
  facet_wrap(~Year)

ggsave(p,
       filename = file.path(figures_dir, paste0("ntl_map_","12_17_22",".png")),
       height = 5, width = 8,
       dpi = 1000)

