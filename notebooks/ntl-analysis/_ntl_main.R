# Nighttime Lights Analysis: Main Script

# Filepaths ---------------------------------------------------------------------
if(Sys.info()[["user"]] == "robmarty"){
  git_dir  <- "~/Documents/Github/morocco-earthquake-impact"
  proj_dir <- "~/Dropbox/World Bank/Side Work/Morocco Economic Monitor and Earthquake Impact"
} 

data_dir      <- file.path(proj_dir, "Data")
ntl_dir       <- file.path(data_dir, "night-time-lights")
gas_flare_dir <- file.path(data_dir, "gas-flaring")
admin_bnd_dir <- file.path(data_dir, "shapefiles")

git_ntl_dir          <- file.path(git_dir, "notebooks", "ntl-analysis")
git_ntl_clean_dir    <- file.path(git_ntl_dir, "01_clean_data")
git_ntl_analysis_dir <- file.path(git_ntl_dir, "02_analysis")

figures_dir  <- file.path(git_dir, "notebooks", "ntl-analysis", "figures")
tables_dir   <- file.path(git_dir, "notebooks", "ntl-analysis", "tables")

# Packages ---------------------------------------------------------------------
# devtools::install_github("ramarty/blackmarbler")

library(tidyverse)
library(janitor)
library(scales)
library(readxl)
library(lubridate)
library(ggpubr)
library(sf)
library(raster)
library(exactextractr)
library(blackmarbler)
library(ggrepel)
library(gt)
library(gtExtras)
library(leaflet)
library(leaflet.extras)

# Code -------------------------------------------------------------------------
if(F){
  
  #### Clean data
  source(file.path(git_ntl_clean_dir, "01_download_blackmarble.R"))
  source(file.path(git_ntl_clean_dir, "02_extract_to_polygons.R"))
  source(file.path(git_ntl_clean_dir, "03_eq_intensity_by_adm.R"))
  
  #### Analysis (figures)
  source(file.path(git_ntl_analysis_dir, "adm_tables.R"))
  source(file.path(git_ntl_analysis_dir, "annual_trends.R"))
  source(file.path(git_ntl_analysis_dir, "daily_trends.R"))
  source(file.path(git_ntl_analysis_dir, "map_ntl_annual.R"))
  source(file.path(git_ntl_analysis_dir, "percent_change_adm.R"))
}
