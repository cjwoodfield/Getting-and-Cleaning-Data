library(data.table)
library(dplyr)

#Load and Create a List for the Measures (Columns) we want to see in our data
    Measures <- fread("~\\UCI HAR Dataset\\features.txt")
    Measures <- Measures[["V2"]]
    RequiredColumns <- grep(c("mean|std"),Measures,value = TRUE)

#Load And Rename Activity Data
    ActivityLabels <- fread("~\\UCI HAR Dataset\\activity_labels.txt")
    colnames(ActivityLabels) <- c("ActivityTypeNumber","Activity")

#Load And Rename Test Data
    Test <- fread("~\\UCI HAR Dataset\\test\\X_test.txt")
    colnames(Test) <- Measures
    Test <- Test[,RequiredColumns,with = F]
    
    # Load and Rename Test Subjects
    TestSubjects<- fread("~\\UCI HAR Dataset\\test\\subject_test.txt")
    colnames(TestSubjects)[1] <- "PersonNumber"
    
    #Load and Rename Test activities
    TestActivities<- fread("~\\UCI HAR Dataset\\test\\y_test.txt")
    colnames(TestActivities)[1] <- "ActivityTypeNumber"
    
    #Column all the Test Data Tpgether
    TestDatacBind <- cbind(TestSubjects,TestActivities,Test)
    
#Load And Rename Train Data
    Train <- fread("~\\UCI HAR Dataset\\train\\X_train.txt")
    colnames(Train) <- Measures
    Train <- Train[,RequiredColumns,with = F]
    
    # Load and Rename Test Subjects
    TrainSubjects<- fread("~\\UCI HAR Dataset\\train\\subject_train.txt")
    colnames(TrainSubjects)[1] <- "PersonNumber"
    
    #Load and Rename Test activities
    TrainActivities<- fread("~\\UCI HAR Dataset\\train\\y_train.txt")
    colnames(TrainActivities)[1] <- "ActivityTypeNumber"
    
    # Column Bind all the train Data together
    TrainDatacBind <- cbind(TrainSubjects,TrainActivities,Train)

#Stack the Test and Train Data Together
    TestandTrainDataStacked <- rbind(TestDatacBind,TrainDatacBind)

#Aggregate by person Number and Activity Number, Merge with Activity Labels and Re-order
    AggregateDT <- aggregate(.~PersonNumber + ActivityTypeNumber, TestandTrainDataStacked, mean)
    AggregateDT <- merge(x = AggregateDT,y = ActivityLabels,by = "ActivityTypeNumber", all.x = T)
    AggregateDT = AggregateDT %>% select(PersonNumber, ActivityTypeNumber, Activity, everything())
    
#Write Table
    write.table(AggregateDT,file = "Getting&CleaningDataProject_ChrisWoodfield.txt", row.name=FALSE)
    
# Getting-and-Cleaning-Data
