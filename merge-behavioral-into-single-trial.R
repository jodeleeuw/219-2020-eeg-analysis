library(dplyr)
library(readr)

single.trial.data <- read_csv('data/eeg/generated/all_single_trial.csv')
behavioral.data <- read_csv('data/behavioral/generated/behavioral_data.csv', 
                            col_types = c("cccddcccccddcccccl"))

slim.behavioral.data <- behavioral.data %>%
  filter(phase=="test") %>%
  mutate(rt = as.numeric(rt)) %>%
  rowwise() %>%
  mutate(subject = tail(str_split(participant_id, pattern="_")[[1]], n=1)) %>%
  ungroup() %>%
  select(subject, correct, rt, match_type, audio_type, image_category, sound_category) %>%
  group_by(subject, match_type, audio_type) %>%
  mutate(trial=1:n()) %>%
  ungroup()


eeg.log.files <- dir('data/eeg/logs')
all.log.data <- NA
for(f in eeg.log.files){
  subject <- str_split(f, pattern="_")[[1]][3]
  log.data <- read_tsv(paste0('data/eeg/logs/', f), col_types = "cdlllc")
  log.data$subject <- subject
  if(all(is.na(all.log.data))){
    all.log.data <- log.data
  } else {
    all.log.data <- bind_rows(all.log.data, log.data)
  }
}

slim.log.data <- all.log.data %>% 
  select(subject, Category, `Segment Good`) %>%
  group_by(subject, Category) %>%
  mutate(correct.trial.index=1:n()) %>%
  ungroup() %>%
  mutate(match_type = str_sub(Category, 1, 2), match_type = if_else(match_type == "co", "match", "non-match")) %>%
  mutate(audio_type = str_sub(Category, 3, 4), audio_type = if_else(audio_type == "so", "sound", "label"))

slim.correct.beh.data <- slim.behavioral.data %>% 
  filter(correct==T) %>%
  group_by(subject, match_type, audio_type) %>%
  mutate(correct.trial.index=1:n()) %>%
  ungroup()

slim.all <- slim.log.data %>% left_join(slim.correct.beh.data, by=c("subject", "match_type", "audio_type", "correct.trial.index"))

merged.data <- slim.all %>% 
  filter(`Segment Good` == TRUE) %>% 
  group_by(subject, match_type, audio_type) %>%
  mutate(trial=1:n()) %>%
  mutate(congruence = match_type, audio = audio_type)

subject.test <- subject.06.single %>% 
  ungroup() %>% 
  mutate(trial = as.numeric(trial)) %>% left_join((merged.data %>% filter(subject=="06")), by=c("subject", "trial", "congruence", "audio"))





