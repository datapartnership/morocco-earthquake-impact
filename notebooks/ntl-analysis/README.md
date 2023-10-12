# Night Time Lights in Morocco

Nighttime lights have become a commonly used resource to estimate changes in local economic activity. This section shows where nighttime lights are concentrated across Morocco and observed changes over time.

## Data

We use nighttime lights data from VIIRS Black Marble data. Raw nighttime lights data requires correction due to cloud cover and stray light, such as lunar light. Black Marble datasets apply algorithms to correct raw nighttime light values and calibrate data so that trends in lights over time can be meaningfully analyzed. 

The raw values of nighttime lights are radiance of lights, and the values themselves are not readily interpretable in an economic context. Nighttime light values should be viewed as an index, with larger values reflecting brighter lights---and more economic activity. 

For further information, please refer to {ref}`foundational_datasets`.

## Methodology

We extract nighttime lights at different administrative levels. The following code cleans the data:

* [Download VIIRS Black Marble data](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/01_clean_data/01_download_blackmarble.R) Downloads nighttime light BlackMarble data as raster files.
* [Aggregate Nighttime Lights to Polygons](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/01_clean_data/02_extract_to_polygons.R) The code creates analysis-ready code files, in OneDrive in `Data/night-time-lights/aggregated-to-polygons`. Data are aggregated to different administrative zones.

The following code produces the figures:

* [NTL 2022 Map](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/02_analysis/map_ntl_annual_2022.R)
* [Annual Trends in NTL](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/02_analysis/annual_trends.R)
* [Monthly Trends in NTL](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/02_analysis/monthly_trends.R)
* [Percent Change Maps and Tables](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/02_analysis/percent_change_adm.R)
* [VIIRS and DMSP Comparison](https://github.com/datapartnership/morocco-earthquake-impact/blob/main/notebooks/ntl-analysis/02_analysis/viirs_dmsp.R)

## Results

### Map of Nighttime Lights

The below figure shows maps of nighttime lights in different years. Maps of individual years for all years can be found [here](https://github.com/datapartnership/morocco-earthquake-impact/tree/main/notebooks/ntl-analysis/figures/annual_ntl_maps).

```{figure} figures/ntl_map_12_17_22.png
---
scale: 15%
align: center
---
Map of Nighttime Lights
```

### Trends in Nighttime Lights: Annual

The below figures show trends in nighttime lights across the country (top figure) and at the first administrative division level (bottom figure).

```{figure} figures/annual_trends_adm0.png
---
scale: 40%
align: center
---
Annual Trends in Nighttime Lights: Country Level
```

```{figure} figures/annual_trends_adm1.png
---
scale: 40%
align: center
---
Annual Trends in Nighttime Lights: ADM 1 Level
```

### Trends in Nighttime Lights: Daily

The below figures show trends in nighttime lights across the country, and at the first administrative division level, and within regions by earthquake intensity.

```{figure} figures/daily_trends_adm0.png
---
scale: 40%
align: center
---
Daily Trends in Nighttime Lights: Country Level
```

```{figure} figures/daily_trends_adm1.png
---
scale: 40%
align: center
---
Daily Trends in Nighttime Lights: ADM 1 Level
```

```{figure} figures/daily_trends_eq_indiv.png
---
scale: 40%
align: center
---
Daily Trends in Nighttime Lights: Earthquake Intensity
```

```{figure} figures/daily_trends_eq_range.png
---
scale: 40%
align: center
---
Daily Trends in Nighttime Lights: Earthquake Intensity
```

### Nighttime Lights: ADM2 and ADM3

The below tables show average nighttime lights at ADM2 and ADM3 levels for 2014, 2023 (before the earthquake), and 2023 (after the earthquake). For 2023, we take the average of daily nighttime lights for the respective time periods.

The below tables show the 30 administrative zones with the largest earthquake intensities. The csv files [here](https://github.com/datapartnership/morocco-earthquake-impact/tree/main/notebooks/ntl-analysis/tables/ntl_adm2_adm3) provide data for all administrative zones.

```{figure} figures/eq_table_adm2.png
---
scale: 40%
align: center
---
Annual Nighttime Lights: ADM 2 Level
```

```{figure} figures/eq_table_adm3.png
---
scale: 40%
align: center
---
Annual Nighttime Lights: ADM 3 Level
```

### Change in Nighttime Lights

This section shows the percent change in nighttime lights from 2019, 2020, 2021 until 2022 at different administrative levels. 

#### Maps

```{figure} figures/pc_map_adm1.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 1
```

```{figure} figures/pc_map_adm2.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 2
```

```{figure} figures/pc_map_adm3.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 3
```

```{figure} figures/pc_map_adm4.png
---
scale: 40%
align: center
---
Percent Change in Nighttime Lights: ADM 4
```

