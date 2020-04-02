# Tanner Norton
# Emerson Weather Data Script

# Load libraries
pacman::p_load(devtools,tidyverse, readxl, stringr, stringi,blscrapeR, forcats, skimr, rio, lubridate, riem, 
               dygraphs,epitools, tidyquant, quantmod, timetk, DT, scales, USAboundaries, USAboundariesData,
               ggrepel,sf, maps, geofacet, ggplot2, maptools, buildings, rnaturalearth, rvest, leaflet, 
               prettydoc, magrittr, cdlTools, htmltools, viridis, RColorBrewer, riem, weathermetrics)


# Create a function that calculates felt tempurature vs actual

# Shows when tempurates are above 80 and humidity above 40% which is NOAAs heat index
SLC <- read_csv("C:/Users/User/Documents/Winter 2020/Math  488/Emerson_weather/data_weather/data/utah/SLC.csv") %>% 
  separate(valid, into = c("Date", "Time"), sep = 10) %>% 
  filter(!is.na(tmpf),
         tmpf > 80,
         relh > 40) %>% 
  group_by(Date) %>% 
  mutate(mean_temp = mean(tmpf))
  

SLC_2018_now <- riem_measures(station = "SLC", date_start = "2018-01-01") %>% 
  separate(valid, into = c("Date", "Time"), sep = 10) %>% 
  filter(!is.na(tmpf),
         tmpf > 80,
         relh > 40) %>% 
  group_by(Date) %>% 
  mutate(mean_temp = mean(tmpf)) %>% 
  select(station, Date, Time, lon, lat, tmpf, relh)




# Find Idaho weather stations pull weather from bonniville, jeffereson, madison
?riem_stations
ID <- riem_stations(network = "ID_ASOS") %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326, 
           agr = "constant")

plot(ID)

RXE <- riem_measures(station = "RXE", date_start = "2019-01-01") %>% 
  separate(valid, into = c("Date", "Time"), sep = 10) %>% 
  filter(!is.na(tmpf)) %>% 
  mutate(mean_temp = mean(tmpf),
         HI = heat.index(t = tmpf,
                                   rh = relh,
                                   temperature.metric = "fahrenheit",
                                   output.metric = "fahrenheit")) %>% 
  select(station, Date, Time, lon, lat, tmpf, relh, HI)

IDA <- riem_measures(station = "IDA", date_start = "2019-01-01") %>% 
  separate(valid, into = c("Date", "Time"), sep = 10) %>% 
  filter(!is.na(tmpf)) %>% 
  mutate(mean_temp = mean(tmpf),
         HI = heat.index(t = tmpf,
                         rh = relh,
                         temperature.metric = "fahrenheit",
                         output.metric = "fahrenheit")) %>% 
  select(station, Date, Time, lon, lat, tmpf, relh, HI)





# Find CA weather Stations

CA <- riem_stations(network = "CA_ASOS") %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326, 
           agr = "constant")

plot(CA)

leaflet(CA) %>% setView(lng = -120, lat = 40, zoom = 4.5) %>% addTiles() %>% 
  addMarkers(lng = ~lon, lat = ~lat)



DAG <- riem_measures(station = "DAG", date_start = "2019-01-01") %>% 
  separate(valid, into = c("Date", "Time"), sep = 10) %>% 
  filter(!is.na(tmpf)) %>%  
  mutate(mean_temp = mean(tmpf),
         HI = heat.index(t = tmpf,
                         rh = relh,
                         temperature.metric = "fahrenheit",
                         output.metric = "fahrenheit")) %>% 
  select(station, Date, Time, lon, lat, tmpf, relh, HI)
  






