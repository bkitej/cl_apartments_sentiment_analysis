source('functions.r')

# basic sentiment analysis function, using the AFINN lexicon from tidytext

get_sentiment_afinn = function(text) {
    afinn = get_sentiments('afinn')
    wcount = wc(text)
    s = inner_join(wcount, afinn)
    sentiment = sum(s$freq * s$score)
    return(sentiment)
}




# sentiment analysis using the slightly more complex NRC lexicon from tidytext

nrc = get_sentiments('nrc')
sentiment_titles = nrc$sentiment %>% unique()

sentiments_nrc = function(text) {
    backbone = data.frame(sentiment = sentiment_titles)

    wcount = wc(text, remove_stop_words = FALSE)
    s = inner_join(wcount, nrc)
    
    if(nrow(s) > 0) {
        s = aggregate(freq~sentiment, s, sum)
    }
    
    s = full_join(backbone, s)
    return(s$freq)
}

get_sentiments_nrc = function(df, col_name) {
    x = sapply(df[,col_name], sentiments_nrc)
    x = x %>% t()
    row.names(x) = NULL
    x = as.data.frame(x)
    names(x) = sentiment_titles
    x[is.na(x)] = 0
    df = df %>% cbind(x)
    
    y = x[,sentiment_titles %notin% c('positive','negative')]
    y = as.matrix(y)
    y = prop.table(y, margin = 1)
    y = as.data.frame(y)
    names(y) = paste0(names(y),'_proportion')
    df = df %>% cbind(y)
    
    z = x[,c('positive','negative')]
    z = as.matrix(z)
    z = prop.table(z, margin = 1)
    z = as.data.frame(z)
    names(z) = paste0(c('positive','negative'), '_proportion')
    df = df %>% cbind(z)
    
    return(df)
}