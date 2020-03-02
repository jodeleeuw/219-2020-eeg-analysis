library(dplyr)
library(ggplot2)

subjects <- c("01", "02", "03", "05", "07", "08", "09", "10", "11", "12", "15", "16", "17", "18", "19", "20") #c("01", "02", "03", "05", "07", "08", "09")

for(s in subjects){
  load(paste0("data/eeg/generated/subject_",s,".Rdata"))
  
  x <- get(paste0("subject.",s)) %>% 
    group_by(subject, congruence, audio, electrode, t) %>%
    summarize(voltage = mean(value))
  
  assign(paste0("subject.",s,".averaged"), x)
  
  save(list=paste0("subject.",s,".averaged"), file=paste0('data/eeg/generated/subject_',s,'_averaged.Rdata'))
  
  rm(list=paste0("subject.",s,".averaged"))
  rm(list=paste0("subject.",s))
  rm(x)
}

for(s in subjects){
  load(paste0("data/eeg/generated/subject_",s,"_averaged.Rdata"))
}

x <- sapply(sapply(ls(), get), is.data.frame)
dfs <- names(x)[(x==TRUE)]

eeg.averaged <- get(dfs[1])
for(d in dfs[2:length(dfs)]){
  eeg.averaged <- rbind(eeg.averaged, get(d))
}

occipital <- c(67,77,65,90,68,94,70,83)
parietal <- c(13, 112, 6, 30, 105, 129, 37, 87, 55)
location.left <- c(68, 65,70, 67)
location.right <- c(77,90,94,83)

eeg.averaged <- eeg.averaged %>% 
  mutate(location = if_else(electrode %in% occipital, "occipital", "parietal")) %>%
  mutate(hemisphere = if_else(
    electrode %in% location.left, "left",
    if_else(electrode %in% location.right, "right", "central")))

save(eeg.averaged, file="data/eeg/generated/all_averaged.Rdata")
write_csv(eeg.averaged, path="data/eeg/generated/all_averaged.csv")