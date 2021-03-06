# load libraries
library(dplyr)
library(ggplot2)
library(readr)
# sanbox script for testing code before it's added to the markdown document
# load dataset
beer <- read_csv("00_Data/raw/beer_reviews.csv")

# quick data check, front & back
glimpse(beer)
summary(beer)
beer %>% 
    head(10) %>%
    View()

beer %>%
    tail(10) %>%
    View()

# data structure & summary
str(beer)
summary(beer)

# count NAs and missing values
beer %>%
    select(everything()) %>%
    summarise_all(funs(sum(is.na(.))))

# small function to count empty values by column
count_empty <- function(col_name) {
    return(sum(col_name == "", na.rm=TRUE))
}

beer %>%
    select(everything()) %>%
    summarise_all(funs(count_empty(.)))

# notes
# only beer_abv has missing data --> 4.27% of values are missing
# review_profilename has 348 empty values, brewery_name has 15 empty values

beer %>%
    filter(is.na(beer_abv)) %>%
    group_by(brewery_id) %>%
    head(200) %>%
    View()

# convert review_time (unix time stamp) to date-time object
# can use lubridate or anytime to convert
# let's compare time to perform conversion

# lubridate
tic("lubridate conversion...") # start timer
beer %>%
    mutate(review_time = as_datetime(review_time))

toc() # stop timer ---> lubridate conversion...: 32.12 sec elapsed

tic("anytime conversion...") # start timer
beer %>%
    mutate(review_time = anytime(review_time))

toc() # stop timer ----> anytime conversion...: 30.87 sec elapsed

# 1.25 seconds is not enough to differentiate.  lubridate uses UTC unless timezone is set with tz
# anytime uses system timezone; asUTC can be set to TRUE to return UTC
# make a copy of data to manipulate - leave raw data unchanged
beer_processed <- beer %>%
    mutate(review_time = as_datetime(review_time))


# count review by review_profilename
beer_processed %>%
    count(review_profilename, sort = TRUE) %>%
    View()

# avg overall rating by beer_beerid (avg rating per beer)
beer_processed %>%
    group_by(beer_beerid, beer_style, beer_name, brewery_name) %>%
    mutate(avg_review_overall = mean(review_overall)) %>%
    arrange(desc(avg_review_overall)) %>%
    View()

# look at beers with 500 or more reviews
beer_processed %>%
    count(beer_beerid, beer_style, beer_name, brewery_name,sort = TRUE) %>%
    filter(n >= 500) %>%
    View()


beer %>%
    distinct(brewery_name, brewery_id, beer_name, beer_beerid, beer_abv) %>% 
    group_by(brewery_name) %>%
    summarise(mean_abv = mean(beer_abv)) %>% 
    arrange(desc(mean_abv)) %>%
    head(5)

beer_processed <- 
    beer %>% 
    group_by(beer_name, beer_beerid) %>%
    mutate(review_count = n())

beer_processed %>%
    filter(review_count >= 100) %>%
    group_by(beer_name, beer_beerid, brewery_name) %>%
    summarise(mean_overall_rating = mean(review_overall, na.rm=TRUE), n()) %>%
    select(mean_overall_rating, beer_name, everything()) %>%
    arrange(desc(mean_overall_rating, n)) %>%
    head(8)
