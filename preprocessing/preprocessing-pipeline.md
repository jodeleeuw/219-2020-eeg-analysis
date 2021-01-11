The scripts in this folder convert the extracted segment data from our NetStation processing pipeline into forms that are more usable in the analysis scripts.

The input for preprocessing are the files in `/data/eeg/raw-trials`. There is a single text file for each segment in this folder. These files contain the voltage measurements for all 129 electrodes.

# Step 1: load-and-filter-eeg.R

This file loads all of the data files and extracts the target electrodes. It converts the filtered data to a tidy-formatted data frame for each subject. The data frames are then saved in Rdata format in `/data/eeg/generated`.

# Step 2: grand-averages.R



