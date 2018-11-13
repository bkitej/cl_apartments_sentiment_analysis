#
#
#      DATA CLEANING
#
#

source('functions.r')





df = readRDS('../data/cl_apartments.rds')

# basic cleaning: remove unrealistic outliers and unnecessary columns
df = df[which(df$state == 'CA'),]
df = df[which(df$price > 148 & df$price < 1000000),]
df = df[grep('weekly.[^yB]', df$title, ignore.case = TRUE, invert = TRUE),] # remove "weekly" rentals

df$text = clean_text(df$text)
df$title = clean_text(df$title)




south_bay_counties = 
    c(
        'San Francisco',
        'San Mateo',
        'Santa Clara',
        'Alameda',
        'Contra Costa'
    )





sbay = df[which(df$county %in% south_bay_counties),]

sbay = sbay[,names(df) %in% c('title','text','county','place','price','latitude','longitude')]



saveRDS(sbay, file = '../data/sbay.rds')