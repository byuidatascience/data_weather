# This script when run will scrape the tmy3 data from every weather station in the United States. If you need just a few stations 
# it is recommending to go to the website, https://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/tmy3/by_state_and_city.html 
# and download the individual tmy3 files there. 

# Load libraries 
pacman::p_load(tidyverse, rvest, httr, sf, here, lubridate, stringr, downloader, dummies, 
               cluster, factoextra, gridExtra, sf)
# There's a need to scrape all the tmy3 data from every state. 
# Below is is the code to scrape the download links for each weather station/airport. 
# Load the page
main.page <- read_html(x = "https://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/tmy3/by_state_and_city.html")
# Get link URLs
urls <- main.page %>% # feed `main.page` to the next step
  html_nodes(".hide") %>% # get the CSS nodes
  html_attr("href")  # extract the URLs
# Get Airport text
airport <- main.page %>% # feed `main.page` to the next step
  html_nodes("td:nth-child(4)") %>% # get the CSS nodes
  html_text() # extract the airporttext
# Combine `airport` and `urls` into a data.frame
PageList <- data.frame(airport = airport, 
                       urls = urls[urls != "#Top" & urls != "http://www.nrel.gov/rredc"], 
                       stringsAsFactors = FALSE) %>% 
  mutate(urls = str_replace_all(urls, "\\.\\.", "https://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005"))
# With the download links, the downloader package can be used to take all the tmy3 data 
x <- seq(1,970,51)
y <- seq(51,1020,51)
state <- c()
US_tmy3 <- data.frame()
for (url in PageList$urls) {
  box <- tempfile(fileext = ".csv") # Create temporary box to store the individual tmy3
  
  download(url, # Take the url from the PageList and download it 
           mode = "wb", 
           destfile = box) # Send it to the temporary file 
  
  state <- read_csv(box, col_names = FALSE)[1,3][['X3']] # Save the specific state
  name <- read_csv(box, col_names = FALSE)[1,2][['X2']]
  station <- read_csv(url, skip = 1) %>% 
    mutate(StationName = name, 
           State = state) %>% 
    select(1,2,StationName, State, everything()) # Replace the station name each loop
  US_tmy3 <- rbind(US_tmy3, station) # Bind to main dataframe
  US_tmy3[is.na(US_tmy3)] <- 0    # Enters in 00:00 for time when values were null
  
  unlink(box)
} 
