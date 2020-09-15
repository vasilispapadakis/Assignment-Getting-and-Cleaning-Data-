
# Reading train, test tables and merging them with their row subject

training <- read.table(
        "train/X_train.txt", header=FALSE, comment.char = "", quote="\"")

training_subject <- read.table(
        "train/subject_train.txt", header=FALSE, comment.char = "", quote="\"",col.names = "subject")

train_y <- read.table(
        "train/y_train.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "labels")

test <- read.table(
        "test/X_test.txt", header=FALSE, comment.char = "", quote="\"")

test_subject <- read.table(
        "test/subject_test.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "subject")

test_y <- read.table(
        "test/y_test.txt", header=FALSE, comment.char = "", quote="\"" , col.names = "labels")

test <- cbind( test_subject , test_y , test )

training <- cbind(training_subject , train_y , training)

rm(training_subject,train_y,test_subject,test_y)



# Merging the test and training data set into one data set

data <- rbind(test , training)

rm(test , training)



# Mean and standard deviation 

sd_value <- apply( data[ , -1] , 1 , sd )
mean_value <- rowMeans( data[ , -1] )




#Naming the activities

activities <- read.table(
        "activity_labels.txt", header=FALSE, comment.char = "", quote="\"")

data <- merge(data,activities , by.x = "labels" , by.y = "V1" , all = TRUE , )
data <- select(data , subject , labels , V2.y , everything() )



#Naming the Columns

column_names <- read.table(
        "features.txt", header=FALSE, comment.char = "", quote="\"" )
column_names <- column_names[,2]
column_names <- c(names(data[1:2]), "activity" , column_names)
column_names <- make.names(names=column_names, unique=TRUE, allow_ = TRUE)
colnames(data) <- column_names

rm(activities , column_names)



#Calculating the average of each variable for each activity and each subject

data<-group_by(data , subject); data <- group_by(data , activity , add = TRUE )

columns <- names(data) ; columns <- columns[-(1:3)]

mean <- summarize_at(data , .vars = columns ,.funs =  mean )

