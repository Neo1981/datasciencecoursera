##correlation

corr <- function(directory, threshold = 0) {
 
  df = complete(directory)
  ids = df[df["nobs"] > threshold, ]$id
  result = numeric()
  for (i in ids) {
    csvfile <- sprintf("%03d.csv",i)
    filepath <- file.path("C:/",directory,"/", csvfile)
    
    dataset = read.csv(filepath)
    datasetComplete = dataset[complete.cases(dataset), ]
    result = c(result, cor(datasetComplete$sulfate, datasetComplete$nitrate))
    
  }
  return(result)
}
