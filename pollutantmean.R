## PollutantMean

pollutantmean <- function(directory='specdata',pollutant, id=1:332) {
  for (i in id )  {
    if (!exists("dataset")){
      csvfile2 <- sprintf("%03d.csv",i)
      filepath2 <- file.path("C:/",directory,"/", csvfile2)
      dataset <- read.csv(filepath2)
      next
    }
    if (exists("dataset"))   {
      csvfile2 <- sprintf("%03d.csv",i)
      filepath2 <- file.path("C:/",directory,"/", csvfile2)
      temp_dataset <- read.csv(filepath2)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
  } ## end for loop through IDs
  
  
  
  result <- mean(dataset[[pollutant]],na.rm=TRUE)
  
  print(result)
}
