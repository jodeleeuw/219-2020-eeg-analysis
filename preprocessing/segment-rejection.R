library(dplyr)

subjects <- c("01", "02", "03", "05", "06", "07", "08", "09", "10", "11", "12", "15", "16", "17", "18", "19", "20",
              "21", "22", "24", "25", "26", "27", "28", "29", "30", "33", "34", "35", "36", "37", "38", "39", "40", "41") #c("01", "02", "03", "05", "07", "08", "09")

for(s in subjects){
  load(paste0("data/eeg/generated/subject_",s,".Rdata"))
  
  x <- get(paste0("subject.",s)) %>% 
    group_by(subject, congruence, audio, trial) %>%
    summarize(reject = any(abs(value > 75)))
  
  print(s)
  print(sum(x$reject))
  print(nrow(x))
  
  #assign(paste0("subject.",s,".averaged"), x)
  
  #save(list=paste0("subject.",s,".averaged"), file=paste0('data/eeg/generated/subject_',s,'_averaged.Rdata'))
  
  #rm(list=paste0("subject.",s,".averaged"))
  rm(list=paste0("subject.",s))
  rm(x)
}