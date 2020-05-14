
#Set directory

setwd("./Getting and Cleaning Data Course Project.Rproj")

#Download zipped files and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="data.zip")
unzip("data.zip")

#Set WD to unzipped file
setwd("./UCI HAR Dataset/")

#Create a list of all files that need to be read into R for test and train folders, exclude Intertial Signals 
testfiles <- list.files("test", full.names=TRUE, pattern = "test")
trainfiles <- list.files("train",full.names=TRUE, pattern= "train")
file <-c(trainfiles, testfiles)

###########################################################################

#Read in data for all 6 files (3 train, 3 test) to generate list of dataframes that we can cbind/rbind
data <-lapply(file, read.table, stringsAsFactors=FALSE, header=FALSE)

#combine rows of test and train for each of the three data types 
data1 <- mapply ( rbind, data[ c(1:3) ], data[ c(4:6) ] )
                        
#Merge 3 types of data types using cbind
data2 <- cbind(data1[[1]], data1[[2]], data1[[3]])

###########################################################################

#Rename columns
allfeatures<-read.table("features.txt")
features <- allfeatures[2]
setnames(data2, c(1:563), c("subject", features[1:561,], "activity" ) )

#Extract columns that have mean or standard deviation information ; doesn't include subject or activity columns
measurements <- data2[grepl("std|mean", colnames(data2))]

#Create DF with subject, mean/std measurements, activity
data3 <- cbind(data2[1], measurements, data2[563])

#Appropriately labels the data set with descriptive variable names. 1-6 changed to activity labels

activitylabelsdata <-read.table("activity_labels.txt")
data3$activity <- activitylabelsdata$V2[ match( data3$activity, activitylabelsdata$V1)]

###########################################################################

#second, independent tidy data set with the average of each variable for each activity and each subject.
data4 <- aggregate( . ~ subject + activity, data = data3, FUN = mean )
write.table( data4, "averagedata.txt", row.names = FALSE )







