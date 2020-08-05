library(dplyr)
library(ggplot2)
library(tidyverse)
library(shinydashboard)
library(shiny)
library(lubridate)

ur_characters <-read.csv('ur_characters.csv')
mr_characters <-read.csv('mr_characters.csv')
sr_characters <-read.csv('sr_characters.csv')
other_characters <-read.csv('other_characters.csv')

character_list = rbind(ur_characters, mr_characters, sr_characters, other_characters) %>%
  mutate(portrait = as.character(portrait), first.name = as.character(first.name), last.name = as.character(last.name),
         master.ability = as.character(master.ability), job.1 = as.character(job.1), job.2 = as.character(job.2),
         job.3 = as.character(job.3), rarity = as.character(rarity), limited = as.character(limited), 
         region = as.character(region), global_release = as.Date(global_release)) %>%
  mutate(last.name = ifelse(last.name == "NULL", NA, last.name)) %>%
  unite(full.name, c(first.name, last.name), sep =' ', remove = TRUE, na.rm = TRUE) %>%
  mutate(modified.hp = hp/max(hp)*100) %>%
  mutate(total.stats = modified.hp + attack + magic + speed + dexterity + luck) %>%
  mutate(limited = ifelse(limited== 'yes', 'limited', 'non-limited')) %>%
  arrange(full.name)

character_scatterplot = select(.data = character_list , hp, attack, cost, ap, tp, magic, speed, luck, dexterity, rarity, full.name, limited)

characters_by_month = select(character_list, full.name, hp, modified.hp, attack, cost, ap, tp, magic, speed, luck, dexterity, total.stats, global_release) %>%
  mutate(release.month = month(global_release)) %>%
  filter(!is.na(release.month))
