#Getting And Cleaning Data Course Project

#set working directory to course Project Folder. may need to edit on your computer to set to folder you want
setwd ("C:\\Users\\elopez\\Desktop\\Data Science Coursework\\Getting and Cleaning Data\\Week 3")

#check to see if data folder exists.  If not create data folder and download csv file
if(!file.exists("./data")){dir.create("./data")} 

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip file and set path to the files
unzip(zipfile="./data/Dataset.zip",exdir="./data")
filespath <- file.path("./data" , "UCI HAR Dataset")

#Read Test, training and features data for into R
ActivityTestData  <- read.table(file.path(filespath, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrainData <- read.table(file.path(filespath, "train", "Y_train.txt"),header = FALSE)

SubjectTraindata <- read.table(file.path(filespath, "train", "subject_train.txt"),header = FALSE)
SubjectTestdata  <- read.table(file.path(filespath, "test" , "subject_test.txt"),header = FALSE)

FeaturesTestdata  <- read.table(file.path(filespath, "test" , "X_test.txt" ),header = FALSE)
FeaturesTraindata <- read.table(file.path(filespath, "train", "X_train.txt"),header = FALSE)

#merge training and test data sets into datasets for each
combinedSubjectdata <- rbind(SubjectTraindata, SubjectTestdata)
combinedActivitydata <- rbind(ActivityTrainData, ActivityTestData)
combinedFeaturesdata <- rbind(FeaturesTraindata, FeaturesTestdata)

#Create Variables out of names of the datasets in each
names(combinedSubjectdata)<-c("subject")
names(combinedActivitydata)<- c("activity")
dataFeaturesNames <- read.table(file.path(filespath, "features.txt"),head=FALSE)
names(combinedFeaturesdata)<- dataFeaturesNames$V2

#Merge the 3 combined files into one dataset
 
initialdatacombined <- cbind(combinedSubjectdata, combinedActivitydata)
Data <- cbind(combinedFeaturesdata, initialdatacombined)

#isolate mean and standard deviation from each measurement
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Bring in Activity Labels from folder
activityLabels <- read.table(file.path(filespath, "activity_labels.txt"),header = FALSE)

#give meaningful labels to variables in dataset
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Create a secondary tidy dataset
install.packages("plyr")
library(plyr); #loads plyr library
Datatidy<-aggregate(. ~subject + activity, Data, mean)
Datatidy<-Datatidy[order(Datatidy$subject,Datatidy$activity),]
write.table(Datatidy, file = "tidydata.txt",row.name=FALSE)



