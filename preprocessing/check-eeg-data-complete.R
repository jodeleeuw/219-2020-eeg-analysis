library(dplyr)
library(readr)

single.trial.data <- read_csv('data/eeg/generated/all_single_trial.csv')

count.data <- single.trial.data %>% filter(component=="N4") %>% group_by(subject, congruence, audio) %>% summarize(N=n())

write_csv(count.data, path="data/eeg/generated/segment_count.csv")
