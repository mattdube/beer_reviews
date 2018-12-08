# sanbox script for testing code before it's added to the markdown document

library(dplyr)
library(corrplot)
library(Hmisc)
library(tidyr)

hist(rbinom(10000, 20, 0.5))

# get sample
set.seed(5431)
beer_sample <- beer[sample(1:nrow(beer),200000, replace = FALSE),]


beer_sample %>%
    select(everything()) %>%
    summarise_all(funs(sum(is.na(.))))


beer_corr_full_pe <- 
    beer %>%
    dplyr::select(review_overall, review_aroma, review_taste, review_appearance, review_palate) %>%
    cor(method = "pearson")

beer_corr_full_sp <- 
    beer %>%
    dplyr::select(review_overall, review_aroma, review_taste, review_appearance, review_palate) %>%
    cor(method = "spearman")


    
corrplot(beer_corr_full_sp, method="number", type = "upper",tl.cex = 0.75,
         mar=c(0,0,2,0), title = "Spearman rank-order correlation") 

corrplot(beer_corr_full, method="number", type = "upper",tl.cex = 0.75,
         mar=c(0,0,2,0), title = "Pearson correlation") 


plotHistograms <- function(varList, inputData, numCols=2) {
    gather(data=inputData, varList, key = "var", value = "value") %>%
        ggplot(aes(x=value)) +
        geom_histogram(fill="#2b8cbe") +
        facet_wrap(~ var, scales = "free", ncol = numCols) +
        theme(legend.position = "none")
}

num_list <- c("review_overall", "review_aroma", "review_taste", "review_appearance", "review_palate")
plotHistograms(num_list, beer)



hist(rbinom(10000, 20, 0.5))