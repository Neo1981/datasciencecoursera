## complete

complete <- function(directory='specdata', id=1:332) {
  
  df <- data.frame(id= numeric(0), nobs= numeric(0))
  
  for (i in id )  {
    
      csvfile2 <- sprintf("%03d.csv",i)
      filepath2 <- file.path("C:/",directory,"/", csvfile2)
      dataset <- read.csv(filepath2)
  
      totalrows <- nrow(dataset)
      totalincomplete <- sum(is.na(dataset$sulfate))
      totalcomplete <- totalrows - totalincomplete                       

      df <- rbind(df,data.frame(id = i, nobs = totalcomplete))
    
  } ## end for loop through IDs
  
  print(df)
  

}
