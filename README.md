#Assignment-Getting-and-Cleaning-Data

The script i created works as explained below:

Step 1 Reading train, test tables and merging them with their row subject

Step 2 Merging the test and training data set into one data set

Step 3 Naming the activities so we know which subject coresponds to which activity

Step 4 Naming the Columns. The column naming was necessary, not only because it was asked by the project but also because in later data processing many functions returned an error of not acceptaple column names

Step 5 As instructed by the assignment, i selected only the variables of mean or standard deviation 

Step 6 Calculating the average of each variable for each activity and each subject. I used the group_by function to group the data as asked and then created the tidy data set which included the necessary id variables and the mean value of the groups i created 

Step 7 In the last step i saved the tidy data set as .txt, using the write.table function
