library(readr)
library(dplyr)
library(tidyr)
library(stringr)

#"01", "02", "03", "05", "07", "08", "09",
#c( "10", "11", "12", "15", "16", "17", "18", "19", "20", "21", "22", "24", "25", "26", "27", "28", "29", "33", "35", "36", "37", "38", "39", "40", "41")

# HAD TO SKIP: 30, 34


subjects <- c("06", "07", "08", "09", "29", "30", "34")

electrodes <- c(67,77,65,90,68,94,70,83,13,112,6,30,105,129,37,87,55)


for(s in subjects){
  all.files <- dir('data/eeg/raw-trials/', pattern=paste0("COGS219_2020_",s), ignore.case = T)
  all.data <- NA

  for(i in 1:length(all.files)){
    print(paste("SUBJECT",s,"FILE", i))
    file.name <- all.files[i]
    file <- paste0('data/eeg/raw-trials/',file.name)
    
    subject <- str_split(file.name, '_')[[1]][3]
    audio<- ifelse((str_split(file.name, 'blc')[[1]][2]) %>% str_detect('la'), 'label', 'sound')
    congruence <- ifelse((str_split(file.name, 'blc')[[1]][2]) %>% str_detect('_co'), 'match', 'non-match')
    trial <- (str_split(file.name, ',')[[1]][2]) %>% str_extract('\\d+')
    
    all.eeg <- read_tsv(file, col_names=as.character(1:129))
    
    filtered.electrodes <- all.eeg %>% select(electrodes)
    filtered.electrodes <- filtered.electrodes %>%
      mutate(subject = subject, t=-100:599, congruence = congruence, audio=audio, trial=trial)
    
    tidy.data <- pivot_longer(filtered.electrodes, 1:length(electrodes), names_to="electrode")
    if(all(is.na(all.data))){
      all.data <- tidy.data
    } else {
      all.data <- bind_rows(all.data, tidy.data)
    }
  }
  assign(paste0("subject.",s), all.data)
  rm(all.data)
  save(list=paste0("subject.",s), file=paste0('data/eeg/generated/',"subject_",s,'.Rdata'))
  rm(list=paste0("subject.",s))
}
