

# Load necessary packages
packages <- c("data.table", "reshape2", "dplyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

##Assume the path is correct mine is "C:\Users\#####\Desktop\coursera\dataset\data"
path <- getwd()

myDataPath <- file.path(path, "project_data")

trainingSubjects <- fread(file.path(myDataPath, "train", "subject_train.txt"))
TestSubjects  <- fread(file.path(myDataPath, "test" , "subject_test.txt" ))

# Read in the Activity data
TrainingActivity <- fread(file.path(myDataPath, "train", "Y_train.txt"))
TestActivity  <- fread(file.path(myDataPath, "test" , "Y_test.txt" ))

# Read in the Measurements data
TrainingMeasures <- data.table(read.table(file.path(myDataPath, "train", "X_train.txt")))
TestMeasures  <- data.table(read.table(file.path(myDataPath, "test" , "X_test.txt")))

# rbind on the Training and Test Subjects
Subjects <- rbind(trainingSubjects, TestSubjects)
setnames(Subjects, "V1", "subject")

# rbind the Training and Test Activities
Activities <- rbind(TrainingActivity, TestActivity)
setnames(Activities, "V1", "activityNumber")

# combine the data sets
Measures <- rbind(TrainingMeasures, TestMeasures)

# cbind on the subjects to activities
SubjectActs <- cbind(Subjects, Activities)
SubjectActsandMeasures <- cbind(SubjectActs, Measures)

# setKeys:
setkey(SubjectActsandMeasures, subject, activityNumber)

## Read in the 'features.txt' 
AllFeatures <- fread(file.path(myDataPath, "features.txt"))
setnames(AllFeatures, c("V1", "V2"), c("measureNumber", "measureName"))

# Use grepl search function to get mean and std data
MeanSTDMeasures <- AllFeatures[grepl("(mean|std)\\(\\)", measureName)]
MeanSTDMeasures$measureCode <- MeanSTDMeasures[, paste0("V", measureNumber)]

# combine key values to get the needed columns from the data.table,
columnsToSelect <- c(key(SubjectActsandMeasures), MeanSTDMeasures$measureCode)
ActivitiesWithMeasureMeanSTD <- subset(SubjectActsandMeasures, 
                                                select = columnsToSelect)

# ready in activity labels anbd set column names
ReferenceToNames <- fread(file.path(myDataPath, "activity_labels.txt"))
setnames(ReferenceToNames, c("V1", "V2"), c("activityNumber", "activityName"))

# combine data
ActivitiesWithMeasureMeanSTD <- merge(ActivitiesWithMeasureMeanSTD, 
                                               ReferenceToNames, by = "activityNumber", 
                                               all.x = TRUE)

# sory on key values
setkey(ActivitiesWithMeasureMeanSTD, subject, activityNumber, activityName)

# reduce table size using metl function and only pulling in key values
ActivitiesWithMeasureMeanSTD <- data.table(melt(ActivitiesWithMeasureMeanSTD, 
                                                         id=c("subject", "activityName"), 
                                                         measure.vars = c(3:68), 
                                                         variable.name = "measureCode", 
                                                         value.name="measureValue"))

# combine all the codes
ActivitiesWithMeasureMeanSTD <- merge(ActivitiesWithMeasureMeanSTD, 
                                               MeanSTDMeasures[, list(measureNumber, measureCode, measureName)], 
                                               by="measureCode", all.x=TRUE)

# Convert activityName and measureName to factors
ActivitiesWithMeasureMeanSTD$activityName <- 
  factor(ActivitiesWithMeasureMeanSTD$activityName)
ActivitiesWithMeasureMeanSTD$measureName <- 
  factor(ActivitiesWithMeasureMeanSTD$measureName)

# get averages from the data set
measureAverages <- dcast(ActivitiesWithMeasureMeanSTD, 
                          subject + activityName ~ measureName, 
                          mean, 
                          value.var="measureValue")

# export the data to a text file
write.table(measureAverages, file="tidyData.txt", row.name=FALSE, sep = "\t")
