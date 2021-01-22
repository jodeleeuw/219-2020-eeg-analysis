library(osfr)

osf_auth(Sys.getenv("OSF_KEY"))

osf.project <- osf_retrieve_node("cq8g4") 

data.folder <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/eeg", pattern="raw-trials")

# raw eeg data
# can't upload this to OSF anymore now that file size restrictions are in place.
# data.folder.raw.eeg <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/eeg", pattern="raw-trials")
# raw.data.files <- dir('data/eeg/raw-trials/')
# raw.data.files.path <- paste0('data/eeg/raw-trials/', raw.data.files)
# raw.data.files.path[1]
# osf_upload(data.folder.raw.eeg, raw.data.files.path, verbose=T)


# generated eeg data
data.folder.generated.eeg <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/eeg", pattern="generated")
generated.eeg.data.files <- dir('data/eeg/generated/')
generated.eeg.data.files.path <- paste0('data/eeg/generated/', generated.eeg.data.files)
osf_upload(data.folder.generated.eeg, generated.eeg.data.files.path, verbose = T)

# eeg logs
data.folder.logs.eeg <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/eeg", pattern="logs")
logs.eeg.data.files <- dir('data/eeg/logs/')
logs.eeg.data.files.path <- paste0('data/eeg/logs/', logs.eeg.data.files)
osf_upload(data.folder.logs.eeg, logs.eeg.data.files.path, verbose = T)

# behavioral data
data.folder.behavioral.raw <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/behavioral", pattern="raw")
behavioral.raw.data.files <- dir('data/behavioral/raw/')
behavioral.raw.data.files.path <- paste0('data/behavioral/raw/', behavioral.raw.data.files)
osf_upload(data.folder.behavioral.raw, behavioral.raw.data.files.path, verbose = T)

data.folder.behavioral.generated <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/data/behavioral", pattern="generated")
behavioral.generated.data.files <- dir('data/behavioral/generated/')
behavioral.generated.data.files.path <- paste0('data/behavioral/generated/', behavioral.generated.data.files)
osf_upload(data.folder.behavioral.generated, behavioral.generated.data.files.path, verbose = T)

# preprocessing scripts
preprocessing.scripts.folder <- osf.project %>% osf_ls_files(type="folder", path="Data & Analysis/", pattern="preprocessing")
preprocessing.scripts.files <- dir('preprocessing/')
preprocessing.scripts.files.path <- paste0('preprocessing/', preprocessing.scripts.files)
osf_upload(preprocessing.scripts.folder, preprocessing.scripts.files.path, verbose = T)

# analysis scripts
main.folder <- osf.project %>% osf_ls_files(type="folder", pattern="Data & Analysis")
analysis.scripts <- c(
  "analysis-notebook.Rmd",
  "analysis-notebook.nb.html",
  "219-2020-eeg-analysis.Rproj"
)
osf_upload(main.folder, analysis.scripts, verbose=T)
