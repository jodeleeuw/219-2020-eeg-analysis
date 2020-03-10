library(readr)
library(dplyr)

test_data <- read_csv('data/behavioral/longtest_csv.csv')

trials <- test_data %>% filter(phase=="test") %>% group_by(audio_type, match_type) %>% summarize(n=n())
trials <- test_data %>% filter(phase=="test") %>% group_by(audio_type, match_type, stimulus) %>% summarize(n=n())
trials <- test_data %>% filter(phase=="test") %>% group_by(image_category, sound_category) %>% summarize(n=n())
