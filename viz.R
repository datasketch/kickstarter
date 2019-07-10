library(hgchmagic)
all_kick <- read_csv('data/data-kickstarter - general.csv')
all_kick <- all_kick[1:25, -3]
options(scipen = 999)
all_kick$funded_percentage <- (all_kick$pledged/all_kick$goal) * 100

# proyectos con 100% o más recaudados
kick_full <- all_kick %>% 
              filter(funded_percentage >= 100)

# secciones

kick_sect <- kick_full %>% 
              group_by(sections) %>% 
                summarise(total = n())
hgch_bar_CatNum(kick_sect)


# moneda 

kick_money <- kick_full %>% 
               group_by(money_type)%>% 
                summarise(total = n())
hgch_bar_CatNum(kick_money)

# tiempo 



# offers kick

off_kick <- read_csv('data/data-kickstarter - offers.csv')

backers <- off_kick %>%
            drop_na(backers) %>% 
             group_by(money_type, pledge) %>% 
              summarise(backers = sum(backers,na.rm = T))
