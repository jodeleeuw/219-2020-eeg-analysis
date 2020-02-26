library(readr)

all.files <- dir('data/behavioral/raw', pattern = ".csv")

behavioral.data <- read_csv(paste0('data/behavioral/raw/', all.files[1]))

for(i in 2:length(all.files)){
  behavioral.data <- rbind(behavioral.data, read_csv(paste0('data/behavioral/raw/', all.files[i])))
}

write_csv(behavioral.data, path='data/behavioral/generated/behavioral_data.csv')
