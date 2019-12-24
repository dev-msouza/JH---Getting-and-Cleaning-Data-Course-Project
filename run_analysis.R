##### if the library isn't installed uncoment and run the line of code bellow
#install.packages('tidyverse')
#install.packages('colorspace')

library(tidyverse)

#Download course data set
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Create directory to download file
if (!(file.exists("courseData")))
  { dir.create("courseData")}

# will take some time to download ~ 60MB
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile ="courseData/Dataset.zip")

# and now the ziped file need to unzip

unzip("courseData/Dataset.zip",exdir="courseData")

features <- read.csv('./courseData/UCI HAR Dataset/features.txt' , header=FALSE , sep=" ") %>% pull(2)

head(features)

### read the train data

x_train <- read.table("./courseData/UCI HAR Dataset/train/X_train.txt" ,  header=FALSE)

names(x_train) <- features

head(x_train,1)

y_train <- read.table("./courseData/UCI HAR Dataset/train/y_train.txt" , header=FALSE)

names(y_train) <- c('activity')

head(y_train,1)

subject_train <- read.table("./courseData/UCI HAR Dataset/train/subject_train.txt" , header=FALSE)

names(subject_train) <- c('subject')

head(subject_train,1)

train <- bind_cols(subject_train,y_train, x_train) %>% mutate(set="train") %>% select(set, everything())

head(train,1)

rm(list = c("y_train","x_train","subject_train"))

### read the train data
x_train <- read.table("./courseData/UCI HAR Dataset/train/X_train.txt", header=FALSE)
names(x_train) <- features
y_train <- read.table("./courseData/UCI HAR Dataset/train/y_train.txt", header=FALSE)
names(y_train) <- c('activity')
subject_train <- read.table("./courseData/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
names(subject_train) <- c('subject')

### relation
train <- bind_cols(subject_train,y_train, x_train) %>% mutate(set="train") %>% select(set, everything())

### cleaning
rm(list = c("y_train","x_train","subject_train"))

### read the test data
x_test <- read.table("./courseData/UCI HAR Dataset/test/X_test.txt", header=FALSE)
names(x_test) <- features
y_test <- read.table("./courseData/UCI HAR Dataset/test/y_test.txt", header=FALSE)
names(y_test) <- c('activity')
subject_test <- read.table("./courseData/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
names(subject_test) <- c('subject')

### relation
test <- bind_cols(subject_test,y_test, x_test) %>% mutate(set="test") %>% select(set, everything())

### cleaning
rm(list = c("y_test","x_test","subject_test"))

### tidy_data dataset
tidy_data <- bind_rows(train,test)
rm(list = c("test","train"))

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
tidy_data <- tidy_data %>% select(1:3, contains("mean()"), contains("std()"))

## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.delim('./courseData/UCI HAR Dataset/activity_labels.txt', header=FALSE , sep=" ") %>% pull(2)

levels(tidy_data$activity) <- activity_labels

## 4. Appropriately labels the data set with descriptive variable names.
### This was already done during the loading of the data for convenience


## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

avgd_data <- tidy_data %>% group_by(subject, activity) %>% summarise_at(-(1:3),mean,na.rm = T)

### Save this dataset to submit
write.table(avgd_data, file="./courseData/tidy_dataset.txt", row.names = FALSE)
