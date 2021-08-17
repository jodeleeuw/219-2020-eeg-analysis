library(dplyr)
library(readr)
library(pracma)

subjects <- c("01", "02", "03", "05", "06", "07", "08", "09", "10", "11", "12", "15", "16", "17", "18", "19", "20",
              "21", "22", "24", "25", "26", "27", "28", "29", "30", "33", "34", "35", "36", "37", "38", "39", "40", "41") 

p1.window <- 35:90
p2.window <- 170:210
n4.window <- 170:370

occipital <- c(67,77,65,90,68,94,70,83)
parietal <- c(13, 112, 6, 30, 105, 129, 37, 87, 55)
location.left <- c(68, 65,70, 67)
location.right <- c(77,90,94,83)

get.peak.p1 <- function(x){
  peaks <- findpeaks(x)
  if(is.null(peaks)){
    return(NA)
  } else {
    which.peak <- which.max(peaks[,1])
    peak <- peaks[which.peak,]
    offset <- peak[2] - 1
    start <- p1.window[1]
    return(start+offset)
  }
}

get.peak.p2 <- function(x){
  peaks <- findpeaks(x, npeaks=1)
  if(is.null(peaks)){
    return(NA)
  } else {
    which.peak <- which.max(peaks[,1])
    peak <- peaks[which.peak,]
    offset <- peak[2] - 1
    start <- p2.window[1]
    return(start+offset)
  }
}

get.peak.amplitude <- function(x){
  peaks <- findpeaks(x)
  if(is.null(peaks)){
    return(NA)
  } else {
    which.peak <- which.max(peaks[,1])
    peak <- peaks[which.peak,]
    p <- peak[2]
    return(x[p])
  }
}
  

for(s in subjects){
  print(s)
  load(paste0("data/eeg/generated/subject_",s,".Rdata"))
  
  p1.group <- get(paste0("subject.",s)) %>%
    filter(t %in% p1.window, electrode %in% occipital) %>%
    mutate(hemisphere = if_else(
      electrode %in% location.left, "left",
      if_else(electrode %in% location.right, "right", "central"))) %>%
    group_by(subject, congruence, audio, trial, t, hemisphere) %>%
    summarize(merged.voltage = mean(value)) %>%
    group_by(subject, congruence, audio, trial, hemisphere) %>%
    summarize(mean.amplitude = mean(merged.voltage)) %>%
    mutate(component = "P1")
  
  p1.single.trial <- get(paste0("subject.",s)) %>%
    filter(t %in% p1.window, electrode %in% occipital) %>%
    mutate(hemisphere = if_else(
      electrode %in% location.left, "left",
      if_else(electrode %in% location.right, "right", "central"))) %>%
    group_by(subject, congruence, audio, trial, t, hemisphere) %>%
    summarize(merged.voltage = mean(value)) %>%
    group_by(subject, congruence, audio, trial) %>%
    summarize(peak.time = get.peak.p1(merged.voltage), peak.amplitude = get.peak.amplitude(merged.voltage) ) %>%
    mutate(component = "P1")
  
  p1 <- p1.group %>% left_join(p1.single.trial, by=c("subject", "congruence", "audio", "trial", "component"))
   
  p2.group <- get(paste0("subject.",s)) %>%
    filter(t %in% p2.window, electrode %in% occipital) %>%
    mutate(hemisphere = if_else(
      electrode %in% location.left, "left",
      if_else(electrode %in% location.right, "right", "central"))) %>%
    group_by(subject, congruence, audio, trial, t, hemisphere) %>%
    summarize(merged.voltage = mean(value)) %>%
    group_by(subject, congruence, audio, trial, hemisphere) %>%
    summarize(mean.amplitude = mean(merged.voltage)) %>%
    mutate(component = "P2")
  
  p2.single.trial <- get(paste0("subject.",s)) %>%
    filter(t %in% p2.window, electrode %in% occipital) %>%
    mutate(hemisphere = if_else(
      electrode %in% location.left, "left",
      if_else(electrode %in% location.right, "right", "central"))) %>%
    group_by(subject, congruence, audio, trial, t) %>%
    summarize(merged.voltage = mean(value)) %>%
    group_by(subject, congruence, audio, trial) %>%
    summarize(peak.time = get.peak.p2(merged.voltage), peak.amplitude = get.peak.amplitude(merged.voltage) ) %>%
    mutate(component = "P2")
  
  p2 <- p2.group %>% left_join(p2.single.trial, by=c("subject", "congruence", "audio", "trial", "component"))
  
  
  n4 <- get(paste0("subject.",s)) %>%
    filter(t %in% n4.window, electrode %in% parietal) %>%
    group_by(subject, congruence, audio, trial) %>%
    summarize(mean.amplitude = mean(value)) %>%
    mutate(peak.time = NA, peak.amplitude = NA, component="N4", hemisphere=NA)
  
  assign(paste0("subject.",s,".single"), bind_rows(p1,p2,n4))
  
  save(list=paste0("subject.",s,".single"), file=paste0('data/eeg/generated/subject_',s,'_single.Rdata'))
  
  rm(list=paste0("subject.",s,".single"))
  rm(list=paste0("subject.",s))
  rm(list=c("n4","p1","p1.group","p1.single.trial","p2","p2.group","p2.single.trial"))
}

subjects <- c("01", "02", "03", "05", "06", "07", "08", "09", "10", "11", "12", "15", "16", "17", "18", "19", "20",
              "21", "22", "24", "25", "26", "27", "28", "29", "30", "33", "34", "35", "36", "37", "38", "39", "40", "41") 


for(s in subjects){
  load(paste0("data/eeg/generated/subject_",s,"_single.Rdata"))
}

x <- sapply(sapply(ls(), get), is.data.frame)
dfs <- names(x)[(x==TRUE)]

eeg.single <- get(dfs[1])
for(d in dfs[2:length(dfs)]){
  eeg.single <- rbind(eeg.single, get(d))
}

save(eeg.single, file="data/eeg/generated/all_single_trial.Rdata")
write_csv(eeg.single, path="data/eeg/generated/all_single_trial.csv")
