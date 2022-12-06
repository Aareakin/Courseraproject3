filename <- "Coursera_DS3_Final.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20D
ataset.zip"
  download.file(fileURL, filename, method="curl")
}


library(dplyr)
library(tidyr)
library(tidyverse)
Q2_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
aq_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
aq_path <- "C:/Users/Aare Akin/Documents/R work/Training carried out/UCI HAR Dataset"
download.file(aq_Url, aq_Path, method = "curl")



# Read in the 'Activities' and 'features' data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "act
ivity"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjec
t")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Row merge the Training and Test Subjects
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

# changing 
subject_train <- subject_train %>% rename(subject=subjec.t)
Subject <- rbind(subject_train, subject_test)



Merged_Data <- cbind(Subject, Y, X)


TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code, 2]



names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))




aveData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(aveData, "aveData.txt", row.name=FALSE)


str(aveData)



aveData
