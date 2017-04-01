
#download required zipfile
file <- "UCI HAR Dataset.zip"
if(!file.exists(file)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "file", method = "curl")
} else {
  unzip(file)
}

#load train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt")

#load test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")

#merge data sets
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)

#means and standard deviations for each measurements

