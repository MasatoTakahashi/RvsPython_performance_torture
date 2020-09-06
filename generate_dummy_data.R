renv::activate()
rm(list = ls())
library(tidyverse)
library(lubridate)
library(charlatan)

set.seed(71)
n_person <- 10
n_division <- 3
n_company <- 1000000

generate_companynumber <- function(n_company){
  paste0(sample(LETTERS, n_company, replace = T), 
         sample(LETTERS, n_company, replace = T), 
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T),
         sample(0:9, n_company, replace = T)
         ) %>% 
    return
}

ym6 <- NULL
for(y in 2010:2020){
  ym6 <- c(ym6, paste0(y, stringr::str_pad(1:12, 2, pad = '0')))
}
ym6 <- data.frame(ym6) %>% 
  mutate(dummy=1)

person_name <- charlatan::ch_name(n_person) %>% 
  data.frame() %>% 
  mutate(dummy=1)
colnames(person_name) <- c('person_name', 'dummy')
company <- generate_companynumber(n_company) %>% 
  data.frame %>% 
  mutate(dummy=1)
colnames(company) <- c('company_number', 'dummy')
d_transaction <- full_join(ym6, company, by='dummy') %>% 
  select(-dummy)
d_transaction$q <- charlatan::ch_unif(nrow(d_transaction), min=-30000, max=60000)

resp_master <- cbind(sample(person_name$person_name, nrow(company), replace = T), company$company_number) %>% data.frame
colnames(resp_master) <- c('person_name', 'company_number')
resp_master$division <- sample(LETTERS[1:n_division], nrow(resp_master), replace = T) %>% paste0('division-', .)

d <- d_transaction %>% 
  left_join(resp_master, by = 'company_number')

print('data dimension...')
d_transaction %>% dim %>% print

write_csv(d_transaction, 'dummy_transaction_data.csv')
write_csv(resp_master, 'dummy_resp_master.csv')
