
# Reading train, test tables and merging them with their row subject

training <- read.table(
        "UCI HAR Dataset/train/X_train.txt", header=FALSE, comment.char = "", quote="\"")

training_subject <- read.table(
        "UCI HAR Dataset/train/subject_train.txt", header=FALSE, comment.char = "", quote="\"",col.names = "subject")

train_y <- read.table(
        "UCI HAR Dataset/train/y_train.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "labels")

test <- read.table(
        "UCI HAR Dataset/test/X_test.txt", header=FALSE, comment.char = "", quote="\"")

test_subject <- read.table(
        "UCI HAR Dataset/test/subject_test.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "subject")

test_y <- read.table(
        "UCI HAR Dataset/test/y_test.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "labels")

test <- cbind( test_subject , test_y , test )

training <- cbind(training_subject , train_y , training)

rm(training_subject,train_y,test_subject,test_y)



# Merging the test and training data set into one data set

data <- rbind(test , training)

rm(test , training)


#Naming the activities

library(dplyr)

activities <- read.table(
        "UCI HAR Dataset/activity_labels.txt", header=FALSE, comment.char = "", quote="\"")

data <- merge(data,activities , by.x = "labels" , by.y = "V1" , all = TRUE , )
data <- select(data , subject , labels , V2.y , everything() )



#Naming the Columns

column_names <- read.table(
        "UCI HAR Dataset/features.txt", header=FALSE, comment.char = "", quote="\"" )
column_names <- column_names[,2]
column_names <- c(names(data[1:2]), "activity" , column_names)
colnames(data) <- column_names

rm(activities , column_names)


#Keeping the mean and standard deviation columns


tidy_data <- select(.data = data , subject , labels , activity , contains("mean"), contains("std"))

rm(data)

## Labeling the data set with descriptive variable names

names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

names(tidy_data) <- make.names(names=names(tidy_data), unique=TRUE, allow_ = TRUE)

#Calculating the average of each variable for each activity and each subject

tidy_data<-group_by(tidy_data , subject); tidy_data <- group_by(tidy_data , activity , .add = TRUE )

columns <- names(tidy_data) ; columns <- columns[-(1:3)]

tidy_data <- summarize_at(tidy_data , .vars = columns ,.funs =  mean )


write.table(tidy_data ,file = "tidy_data.txt" , row.names = FALSE) 
