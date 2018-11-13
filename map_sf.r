library(ggplot2)
library(ggmap)

# register API key, required for access to Google Maps
register_google('AIzaSyAuBqhGt2vQKIA-8UD64BYLiVbK-KYshGI')

# Get bounding box for the SF bay area
bbox = c(-122.5988227689,37.1865741438,-121.6361457669,38.1561525763)

# get black-and-white toner map of SF bay area within bounding box
m = function() get_stamenmap(bbox, maptype = 'toner', zoom = 10)