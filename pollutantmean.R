## PollutantMean

pollutantmean <- function(directory='specdata',pollutant, id=1:332) {
  for (i in id )  {
    if (!exists("dataset")){
      csvfile <- sprintf("%03d.csv",i)
      filepath <- file.path("C:/",directory,"/", csvfile)
      dataset <- read.csv(filepath)
      next
    }
    if (exists("dataset"))   {
      csvfile <- sprintf("%03d.csv",i)
      filepath <- file.path("C:/",directory,"/", csvfile)
      temp_dataset <- read.csv(filepath)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
  } ## end for loop through IDs
  
  
  
  result <- round(mean(dataset[[pollutant]],na.rm=TRUE),digits=3)
  
  print(result)
}
