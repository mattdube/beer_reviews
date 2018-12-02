library(ggmap)

geocode(c("White House", "Uluru"))

register_google(key = "AIzaSyDGdLAXjjJRpmtx-F91q2UT8lRgTuenHhc", "standard")
tz <- geocode("Tanzania")
tz_map <- get_map("Tanzania")
ggmap(tz_map)


us <- c(left = -125, bottom = 25.75, right = -67, top = 49)
map <- get_stamenmap(us, zoom = 5, maptype = "toner-lite")
ggmap(map)

box <- geocode('Tanzania', output = 'more')


if(source == "google"){
    url_string <- paste("http://maps.googleapis.com/maps/api/geocode/json?address=", posturl, "&key=xxx", sep = "")
} else if(source == "dsk"){
    url_string <- paste("http://www.datasciencetoolkit.org/maps/api/geocode/json?address=", posturl, sep = "")
}