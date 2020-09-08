renv::activate()
rm(list = ls())
library(tidyverse)
library(lubridate)

d_transaction <- read_csv('dummy_transaction_data.csv', 
                          col_types = cols(ym6 = col_character(), 
                                           company_number = col_character(), 
                                           q = col_double()))
resp_master <- read_csv('dummy_resp_master.csv', 
                        col_types = cols(.default = col_character()))

t0 <- Sys.time()
d <- d_transaction %>% left_join(resp_master, by = 'company_number')
d %>% dim %>% print()
print(Sys.time() - t0)


t0 <- Sys.time()
d2 <- d %>% 
  group_by(company_number) %>% 
  summarise(n=n(), x1 = sum(q), x2 = min(q), x3 = max(q), x4 = mean(q))
d2 %>% dim %>% print()
print(Sys.time() - t0)


t0 <- Sys.time()
tmp_d <- d %>% 
  mutate(tmp_ym6 = ym6 %>% paste0('01') %>% ymd) %>% 
  mutate(tmp_ym6_prev = tmp_ym6 %m+% months(1))
d3 <- tmp_d %>% 
  left_join(tmp_d, 
            by = c('tmp_ym6'='tmp_ym6_prev', 'company_number'='company_number'))
d3 %>% dim %>% print
print(Sys.time() - t0)




