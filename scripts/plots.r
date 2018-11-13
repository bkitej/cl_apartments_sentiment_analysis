source('themes.r')
source('map_sf.r')

library(ggplot2)    # plotting
library(ggmap)      # maps
library(gridExtra)  # grid.arrange(), facet_wrap()
library(reshape2)   # melt()

sbay = readRDS('sbay_nrc.r')

sbay_melted = melt(
    sbay[,c('latitude','longitude',setdiff(sentiment_titles, c('positive','negative')))], 
    id.vars = c('latitude','longitude'),
    variable.name = 'sentiment',
    value.name = 'freq')



sentiment_map = ggmap(m()) +
    geom_point(
        data = sbay_melted,
        mapping = aes(
            x = longitude,
            y = latitude,
            color = sentiment,
            size = freq
        ),
        alpha = .01
    ) +
    facet_wrap(~sentiment) +
    theme(legend.position = "none") +
    clean



pos = ggplot(
    data = sbay,
    mapping = aes(
        x = positive,
        y = price)
    ) +

    geom_point(alpha = .05) +
    geom_density2d() +
    xlim(0,75) +
    geom_smooth(method = 'lm')

neg = ggplot(
    data = sbay,
    mapping = aes(
        x = negative,
        y = price)
    ) +

    geom_point(alpha = .05) +
    geom_density2d(color = 'red') +
    xlim(0,75) +
    geom_smooth(method = 'lm')

# pos_prop = ggplot(
#     data = sbay,
#     mapping = aes(
#         x = positive_proportion,
#         y = price)
#     ) +

#     geom_point(alpha = .1) +
#     geom_density2d() +
#     xlim(-0.1,1.1)

# neg_prop = ggplot(
#     data = sbay,
#     mapping = aes(
#         x = negative_proportion,
#         y = price)
#     ) +
# 
#     geom_point(alpha = .1) +
#     geom_density2d(color = 'red') +
#     xlim(-0.1,1.1)