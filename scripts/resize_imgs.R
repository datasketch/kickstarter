
library(tidyverse)
library(dsDesigner)

imgs <- list.files("../static/img/rewards", full.names = TRUE)

map(imgs, function(i){
  img <- image_read(i) %>% img_scale(w = 300, h = 300)
  image_write(img, i)
})

