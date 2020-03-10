library(readr)
library(dplyr)

all.files <- dir('data/behavioral/raw', pattern = ".csv")

behavioral.data <- read_csv(paste0('data/behavioral/raw/', all.files[1]), col_types = "cccddcccccddcccccl")

for(i in 2:length(all.files)){
  behavioral.data <- bind_rows(behavioral.data, read_csv(paste0('data/behavioral/raw/', all.files[i]), col_types = "cccddcccccddcccccl"))
}

behavioral.data <- behavioral.data %>%
  mutate(rt = as.numeric(rt)) %>%
  rowwise() %>%
  mutate(participant_id = tail(str_split(participant_id, pattern="_")[[1]], n=1))

write_csv(behavioral.data, path='data/behavioral/generated/behavioral_data.csv')
