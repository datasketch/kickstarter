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
data$id <- 1:nrow(data)
data$thumbnail <- paste0("/img/lie/thumbs/",data$id,".png") 
imgs <- data$image_url

map(seq_along(imgs), ~download.file(imgs[.], paste0("../static/img/lie/original/",.,".png")))

library(dsDesigner)

dir.create("../static/img/lie/thumbs")
file.copy(list.files("../static/img/lie/original", full.names = TRUE), 
          "../static/img/lie/thumbs", overwrite = TRUE)
imgs <- list.files("../static/img/lie/thumbs", full.names = TRUE)

map(imgs, function(i){
  img <- image_read(i) %>% img_scale(w = 300, h = 225)
  image_write(img, i)
})


library(jsonlite)

json <- jsonlite::toJSON(data)
writeLines(json, "../data/ebook.json")
