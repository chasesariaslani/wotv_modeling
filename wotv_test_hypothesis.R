library(ggplot2)
library(tidyverse)
library(lubridate)

ur_characters <-read.csv('ur_characters.csv')
mr_characters <-read.csv('mr_characters.csv')
sr_characters <-read.csv('sr_characters.csv')
other_characters <-read.csv('other_characters.csv')

# character_list generates a list that cleans the data and contains total.stats
# total.stats uses the sum of attack, magic, speed, dexterity, luck and a modified version of hp.
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

# All lists will be based on UR.
original_avg_stat <- mutate(.data=character_list, release.month = month(global_release)) %>%
  filter(rarity == "UR") %>%
  group_by(release.month) %>%
  summarise(avg.stats = mean(total.stats))
original_avg_stat[1,2] # 742
new_avg_stat <- mean(original_avg_stat[[2]])# 773.8

remove_original_characters_list <- mutate(.data=character_list, release.month = month(global_release)) %>%
  filter(rarity == "UR") %>%
  filter(release.month != 3 | is.na(release.month)) # Only contains characters after 3-25 release (includes JP)

mean(remove_original_characters_list[,24]) #786.9

t.test(remove_original_characters_list$total.stats, mu=773.8) # Failed to reject p-vaule = 0.2937

limited_characters_list = character_list %>%
  filter(limited == "limited", rarity == "UR")
mean(limited_characters_list$total.stats) # 784.83
non_limited_characters_list = character_list %>%
  filter(limited == 'non-limited', rarity == "UR")
mean(non_limited_characters_list$total.stats) #768.54

t.test(limited_characters_list$total.stats, mu=768.54) # Failed to reject p-value = 0.4527


# Conclusion: There is no clear indication of characters being overpowered as time goes on. As the JP characters come to Global servers,
# we can expect no power creeping up until the end of of August.