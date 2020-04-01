# Tanners Master Script

# Load libraries
pacman::p_load(devtools,tidyverse, readxl, stringr, stringi,blscrapeR, forcats, skimr, rio, lubridate, riem, 
               dygraphs,epitools, tidyquant, quantmod, timetk, DT, scales, USAboundaries, USAboundariesData,
               ggrepel,sf, maps, geofacet, ggplot2, maptools, buildings, rnaturalearth, rvest, leaflet, 
               prettydoc, magrittr, cdlTools, htmltools, viridis, RColorBrewer, riem, weathermetrics, here)

#set working directory to project directory.


# Dynamic loop to pull all the weather dataframes
states <- c("ID", "FL", "MA", "CA", "IL", "UT")


for (st in states) {
  WeatherStation <- read_csv(paste("derived_data/", st, "_tmy3/", st, "_WeatherStationList.csv", sep = "")) %>% 
    mutate(StationName = Name)
  
  # Loop to read in all the weather station/airport data
  tmy3 <- data.frame() # Empty Dataframe to put tmy3 info
  
  for (name in WeatherStation$Name){
    station <- read_csv(paste("derived_data/",st,"_tmy3/",name,".csv",sep=""), skip = 1) %>% 
      mutate(StationName = name) %>% 
      select(1,2,StationName,everything()) # Replace the station name each loop
    tmy3 <- rbind(tmy3, station) # Bind to main dataframe
    tmy3[is.na(tmy3)] <- 0    # Enters in 00:00 for time when values were null
    print(name) # indicator for how it's moving *shrug* 
  }
  
  nam <- paste(st,"_tmy3", sep = "")
  assign(nam,tmy3)
}


CA_tmy3 <- CA_tmy3 %>% 
  filter(month(mdy(`Date (MM/DD/YYYY)`)) == 1) %>% 
  filter(hour(ID_tmy3$`Time (HH:MM)`) == 6)


  ggplot( aes(x = `GHI (W/m^2)`, y = `DNI (W/m^2)`)) +
  geom_point()


CA_tmy3 %>% 
  filter(hour(CA_tmy3$`Time (HH:MM)`) == 12) %>% 
  ggplot( aes(x = `GHI (W/m^2)`, y = `Dry-bulb (C)`)) +
  geom_point()


cor(ID_tmy3$`GHI (W/m^2)`, ID_tmy3$`DNI (W/m^2)`)

cor(ID_tmy3$`GHI (W/m^2)`, ID_tmy3$`Dry-bulb (C)`)


# CA summaries
CA_tmy <- CA_tmy3 %>% 
    mutate(Month = month(mdy(`Date (MM/DD/YYYY)`)),
           Day = day(mdy(`Date (MM/DD/YYYY)`)),
           Time = hour(hms(`Time (HH:MM)`))) %>% 
  select(Month, Day, Time, `Date (MM/DD/YYYY)`, everything()) %>% 
  group_by(Month, Time, StationName) %>% 
  summarise(med_ghi = median(`GHI (W/m^2)`),
            med_dni = median(`DNI (W/m^2)`),
            med_temp = median(`Dry-bulb (C)`)) %>% 
  filter(StationName == "Los Angeles Intl Arpt") 
           
           

ggplot(CA_tmy, aes(x = Month, y = `Time (HH:MM)`, fill = med_ghi)) +
  geom_tile(color = "white", size = .1, stat = "identity") +
  scale_fill_viridis() +
  labs(title = , x = "Month", y = "Hour of Day")




# Can we show how to predict the delay in energy consumption



# Join simulated supermarket LA store to the CA_tmy data to see how energy consumption and the other
# weather variables affect eachother?
# CA summaries
CA_tmy <- CA_tmy3 %>% 
  filter(StationName == "Los Angeles Intl Arpt") %>% 
  mutate(Month = month(mdy(`Date (MM/DD/YYYY)`)),
         Day = day(mdy(`Date (MM/DD/YYYY)`)),
         Time = hour(hms(`Time (HH:MM)`))) %>% 
  separate("Date (MM/DD/YYYY)", into = c("Date", "Year"), sep = 5) %>% 
  select(Date, Time, everything(), - Year)

# write_csv(CA_tmy, "CA_tmy.csv")


store <- read_xlsx("C:/Users/User/Documents/Winter 2020/Math  488/emerson_data_WI20/derived_data/Supermarket_full_year.xlsx") %>% 
  separate('Date/Time' , into = c("Date (MM/DD/YYYY)", "Time (HH:MM)"), sep = 6) %>% 
  mutate(Time = hour(hms(`Time (HH:MM)`)),
         month = month(dmy(`Date (MM/DD/YYYY)`)),
         Date = `Date (MM/DD/YYYY)`) %>% 
  select(Date, Time, `Time (HH:MM)`, everything(), -month, -`Date (MM/DD/YYYY)`)

# write_csv(store, "store.csv")

store <- read_csv("C:/Users/User/Documents/Winter 2020/Math  488/emerson_data_WI20/personal_folders/nortont/store.csv")

CA_tmy <- read_csv("C:/Users/User/Documents/Winter 2020/Math  488/emerson_data_WI20/personal_folders/nortont/CA_tmy.csv")



# The LA simulation data joined with the LAX airport
# Data should be joined by date or month as well
# The problem is the sim data is for one day 7/9
# This data shows just month of July
LA_sim <- CA_tmy %>% 
  left_join(store, by = c("Date","Time (HH:MM)"))


LA <- store %>% 
  left_join(CA_tmy, by = c("Date", "Time (HH:MM)"))











# CA summaries
CA_tmy <- CA_tmy3 %>% 
  filter(StationName == "Los Angeles Intl Arpt") %>% 
  mutate(Month = month(mdy(`Date (MM/DD/YYYY)`)),
         Day = day(mdy(`Date (MM/DD/YYYY)`)),
         Time = hour(hms(`Time (HH:MM)`))) %>% 
  separate("Date (MM/DD/YYYY)", into = c("Date", "Year"), sep = 5) %>% 
  select(Date, Time, everything(), - Year)
  


store_year <- read_csv("C:/Users/User/Documents/Winter 2020/Math  488/emerson_data_WI20/derived_data/Supermarket_full_year.csv") %>% 
  separate('Date/Time' , into = c("Date (MM/DD/YYYY)", "Time (HH:MM)"), sep = 6) %>% 
  mutate(Time = hour(hms(`Time (HH:MM)`)),
         month = month(dmy(`Date (MM/DD/YYYY)`)),
         Date = `Date (MM/DD/YYYY)`) %>% 
  select(Date, Time, everything(), -month, -`Date (MM/DD/YYYY)`, - `Time (HH:MM)`)
  

is.data.frame(store_year)
is.data.frame(CA_tmy)


# The LA simulation data joined with the LAX airport

# Data should be joined by date or month as well
# The problem is the sim data is for one day 7/9
# This data shows just month of July

LA <- store_year %>% 
  left_join(CA_tmy)























