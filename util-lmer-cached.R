lmer.cached <- function(file, ...){
  set.seed(12604)
  file <- paste0(file, ".rds")
  if(file.exists(file)){
    return(readRDS(file))
  } else {
    model <- lmer(...)
    saveRDS(model, file)
    return(model)
  }
}

glmer.cached <- function(file, ...){
  set.seed(12604)
  file <- paste0(file, ".rds")
  if(file.exists(file)){
    return(readRDS(file))
  } else {
    model <- glmer(...)
    saveRDS(model, file)
    return(model)
  }
}
