library(readr)
library(dplyr)

tt.data <- read_tsv('data/timing/219_2020_timing_test_result.txt', n_max=500)

mean(tt.data$Offset)
sd(tt.data$Offset)

abs(tt.data$Offset - 60)

table(abs(tt.data$Offset - 60))

(388+35) / 500
