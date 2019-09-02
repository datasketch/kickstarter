library(tidyverse)
library(glue)

library(airtabler)
dotenv::load_dot_env()
db <- airtable(
    base = "appO6QyGRTxVYb5ja",
    tables = c("lies", "pitfalls")
  )

lies <- db$lies$select_all()
pitfalls <- db$pitfalls$select_all()
lies_unnest <- lies %>% unnest(pitfall)


lies_unnest$image_url <- map(seq_along(lies_unnest$Attachments),function(i) {
                            paste0(lies_unnest$Attachments[[i]]$url, collapse = "<br>")
                          }) %>% unlist()


lies_unnest <- lies_unnest %>% 
                 separate_rows(image_url, sep = "<br>") #%>% 
                  #distinct(pitfalls, .keep_all = T)


data <- left_join(lies_unnest, pitfalls, by=c('pitfall'='id'))
data <- data %>%
          plyr::rename(c('Name'='pitfall_name'))

data <- as.data.frame(data)
data <- data[,c(-1, -2, -3, -5, -6, -9, -10, -11)]

library(jsonlite)

json <- jsonlite::toJSON(data)
writeLines(json, "data/ebook.json")
