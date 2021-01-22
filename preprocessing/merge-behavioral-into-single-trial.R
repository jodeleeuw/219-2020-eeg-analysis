library(dplyr)
library(readr)
library(stringr)

single.trial.data <- read_csv('data/eeg/generated/all_single_trial.csv')
behavioral.data <- read_csv('data/behavioral/generated/behavioral_data.csv')

# reduce behavioral data down to key trials, create trial index that will match with EEG trial counts

slim.behavioral.data <- behavioral.data %>%
  filter(phase=="test") %>%
  mutate(rt = as.numeric(rt)) %>%
  mutate(subject=as.character(participant_id)) %>%
  select(subject, correct, rt, match_type, audio_type, image_category, sound_category) %>%
  group_by(subject, match_type, audio_type) %>%
  mutate(trial=1:n()) %>%
  ungroup()

# load eeg logs

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

# use the logs to determine which eeg trials had good segments, to line these
# up with the behavioral data.

# note: not all subjects will have 125 trials here because the logs are only
# including segments where the response was CORRECT.

slim.log.data <- all.log.data %>% 
  select(subject, Category, `Segment Good`) %>%
  group_by(subject, Category) %>%
  mutate(correct.trial.index=1:n()) %>%
  ungroup() %>%
  mutate(match_type = str_sub(Category, 1, 2), match_type = if_else(match_type == "co", "match", "non-match")) %>%
  mutate(audio_type = str_sub(Category, 3, 4), audio_type = if_else(audio_type == "so", "sound", "label")) %>%
  mutate(subject = parse_integer(subject))

# filter down the behavioral data to only include correct trials.

slim.correct.beh.data <- slim.behavioral.data %>% 
  filter(correct==T) %>%
  group_by(subject, match_type, audio_type) %>%
  mutate(correct.trial.index=1:n()) %>%
  ungroup() %>%
  mutate(subject = parse_integer(subject))

# the length of beh and eeg should match

nrow(slim.correct.beh.data) == nrow(slim.log.data)

# join the log.data with behavioral data so that we know which behavioral trials correspond
# with good segments in the EEG

slim.all <- slim.log.data %>% left_join(slim.correct.beh.data, by=c("subject", "match_type", "audio_type", "correct.trial.index"))

# filter out all the bad segments, renumber the trials so that the behavioral trial number corresponds with the
# good & correct response segments in the single.trial.data data frame.

merged.data <- slim.all %>% 
  filter(`Segment Good` == TRUE) %>% 
  group_by(subject, match_type, audio_type) %>%
  mutate(trial=1:n()) %>%
  mutate(congruence = match_type, audio = audio_type) %>%
  ungroup()

# convert subject column in single.trial.data to numeric representation
single.trial.data$subject <- as.numeric(single.trial.data$subject)

single.trial.data.eeg.behavioral <- single.trial.data %>%
  left_join(merged.data, by=c("subject", "congruence", "audio", "trial"))

write_csv(single.trial.data.eeg.behavioral, path="data/eeg/generated/single_trial_eeg_behavioral.csv")




