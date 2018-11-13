library(tidytext) # unnest_tokens, stop_words
library(tibble) # data_frame: doesn't force-convert strings 
library(dplyr) # %>%, anti_join
library(rlist) # for list.append

#
#
# ASSORTED WORD PROCESSING FUNCTIONS AND UTILITY TABLES
#
#





# handy 
'%notin%' = function(x,y)!('%in%'(x,y))





# unique-repeat table
urtable = function(df) {

    uniques = list()
    reps = list()
    not_na = list()
    na = list()

    for(i in names(df)) {
        uniques = list.append(uniques, length(unique(df[,i])))
        not_na = list.append(not_na, sum(!is.na(df[,i])))
        na = list.append(na, sum(is.na(df[,i])))
        repeats = df[duplicated(df[,i]),][,i]
        reps = list.append(reps, length(unique(repeats)))
    }

    counts = data.frame(
        feature = names(df), 
        unique_values = unlist(uniques), 
        unique_values_with_repeats = unlist(reps),
        not_na = unlist(not_na),
        na = unlist(na)
    )

    urtable = counts[order(counts$not_na, decreasing = TRUE),]
    
    return(urtable)
}





# clean text of unneeded words
clean_text = function(text_vector) {
    
    txt = text_vector %>% tolower()
    txt = gsub('[\r\n]', ' ', txt)
    txt = gsub('\\w*[0-9]+\\w*', '', txt)
    txt = gsub('sqft|sq\\.|ft\\.', '', txt)
    txt = gsub('\\W', ' ', txt)
    txt = gsub('this posting', '', txt)
    txt = gsub('u*n*hide', '', txt)
    txt = gsub('apartments*', '', txt)
    txt = gsub('show contact info', '', txt)
    txt = gsub('qr code link to this post', '', txt)
    txt = gsub('approximately', '', txt)
    
    return(txt)
}





# unnest tokens, remove stop words, return count table
wc = function(txt, sort = TRUE, remove_stop_words = TRUE) {

    txt_df = data_frame(lines = 1:length(txt), text = txt)

    words = txt_df %>% unnest_tokens(word, text)
    
    if(remove_stop_words == TRUE) {words = anti_join(words, stop_words)}
    
    wc = count(words, word, sort = sort)
    names(wc) = c('word','freq')
    
    return(wc)
}





# raw token-mean table
# 1. find all posts with each token contained in the text
# 2. compute mean price across posts that contain the token
tmt = function(token_vector, post_vector){
    
    {
        m = sapply(token_vector, function(token) 
        {
            mean(df[grep(token, text_vector), 'price'], na.rm = TRUE)
        })
    }
        
    tmt = data.frame(word = tokenvector, mean_price = m)
    rownames(tmt) = NULL
    
    return(tmt)
}





#
# map each token to its comparison table by integrating relevant functions above.
#

tmtable = function(text_vector, price_vector, n = 50, sub = 1, decreasing = TRUE) {
    
    # tokenize, then count
    tokens = wc(text_vector)
    
    # filter tokens > n
    tokens_n = tokens[which(tokens$freq >= n),]
    
    # 1. find all posts with each token contained in the text
    # 2. compute mean price for said posts
    tmtable = tmt(tokens_n$word, df[sample(1:nrow(df), nrow(df)/sub), c('cleantext','price')])
    
    # merge with token counts, omit NAs, order 
    tmtable = merge(tmtable, tokens_n)
    tmtable = na.omit(tmtable)
    tmtable = tmtable[order(tmtable$mean_price, decreasing = decreasing),]
    
    return(tmtable)
}
