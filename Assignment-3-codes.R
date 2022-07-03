#1. Store the csvfiles into 'storm_99'
storm_99 <- read_csv("https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d1999_c20220425.csv.gz")
storm_99 %% write_csv("file.csv")
summary(storm_99)


#df
storm_99_df <- data.frame(storm_99)

#2. Limit the df to the columns below:
storm_99_df = subset(storm_99_df, select = c(BEGIN_DATE_TIME, END_DATE_TIME, EPISODE_ID, EVENT_ID, STATE, STATE_FIPS, CZ_NAME, CZ_FIPS, CZ_TYPE, EVENT_TYPE, SOURCE, BEGIN_LAT, BEGIN_LON, END_LAT, END_LON))

#3. Arrange the data by the state name: 
storm_99_df  <- arrange(storm_99_df, (STATE))
storm_99_df

#4. Change state and county names to title case: 
storm_99_df$STATE <- str_to_title(storm_99_df$STATE)
storm_99_df$CZ_NAME <- str_to_title(storm_99_df$CZ_NAME)

#5. Limit to the events listed by county FIPS, then remove the column 
storm_99_df <- storm_99_df[storm_99_df$CZ_TYPE == 'C',]
#And drop the column CZ_TYPE from df: 
storms_in_99_df = subset(storm_99_df, select = -c(CZ_TYPE))

#6. Pad the state and county FIPS with a"0" at the beginning and then unite the two columns to make one FIPS column with the 5 or 6 digits
storms_in_99_df$STATE_FIPS <- str_pad(storms_in_99_df$STATE_FIPS, width = 3, side = "left", pad = "0")

#7. Change all the column names to lower case: 
storms_in_99_df <- rename_all(storms_in_99_df, tolower)
storms_in_99_df


#8. There is data that comes with base R on US states. Use that to create a dataframe with these columns:
data("state")
US_State_Info<-data.frame(state=state.name, region=state.region, area=state.area)

#9.	Create a dataframe with the number of events per state in the year of your birth. Merge in the state information dataframe you just created in step 8. Remove any states that are not in the state information dataframe. : 
table(storms_in_99_df$state)
state_storm <- data.frame(table(storms_in_99_df$state))
state_storm <- rename(state_storm, c("state" = "Var1"))

#Combine the dataframes: 
state_storm_merge <- data.frame(merge(state_storm, US_State_Info, by="state"))
state_storm_merge
summary(state_storm_merge)

#10. Create the following plot:
library(ggplot2)
Assignment3_plot <-
  ggplot(state_storm_merge, aes(x = area, y = Freq)) +
  geom_point(aes (color = region)) +
  labs(x = "Land area (square miles)",
       y= "# of storm events in 1999")
Assignment3_plot
