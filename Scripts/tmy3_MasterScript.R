# Master Script

# Load libraries

#set working directory to project directory.
library(tidyverse)
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
