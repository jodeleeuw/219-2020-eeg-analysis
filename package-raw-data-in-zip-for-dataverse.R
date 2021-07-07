library(zip)

setwd('data/eeg/raw-trials')

files.per.zip <- 1000

raw.data.files <- list.files(path=".", full.names = TRUE)

n.zips <- ceiling(length(raw.data.files)/files.per.zip)
for(i in 1:n.zips){
  print(paste(i,"of",n.zips))
  zip::zip(
    zipfile=paste0('raw-data-',i,'.zip'), 
    files=raw.data.files[((i-1)*files.per.zip+1):(min(i*files.per.zip, length(raw.data.files)))],
    mode="cherry-pick"
  )
}
setwd('../..')
for(i in 1:n.zips){
  print(paste(i,"of",n.zips))
  zip::zip(
    zipfile=paste0('raw-data-',i,'.zip'),
    files=paste0('eeg/raw-trials/raw-data-',i,'.zip'),
    mode="mirror"
  )
  file.remove(paste0('eeg/raw-trials/raw-data-',i,'.zip'))
}

# non-raw-eeg data
behavioral.data.files <- list.files(path="behavioral", recursive=T, full.names=TRUE)
generated.eeg.files <- list.files(path="eeg/generated", full.names = TRUE)
log.eeg.files <- list.files(path="eeg/logs", full.names = TRUE)
timing.files <- list.files(path="timing", full.names = TRUE)

zip::zip(
  zipfile="non-raw-eeg-data.zip",
  files=c(behavioral.data.files, generated.eeg.files, log.eeg.files, timing.files)
)
