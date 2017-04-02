#download required zipfile
file <- "UCI HAR Dataset.zip"
if(!file.exists(file)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
} 
if (file.exists(file)) {
  unzip(file)
}

#load features and activity labels
activityid <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels <- as.character(activityid[, 2])
features <- read.table("UCI HAR Dataset/features.txt")
featureslabels <- as.character(features[ ,2])

#code to isolate mean and standard deviation meaures
mean.sd <- grep("-(mean|std)\\(\\)", featureslabels)
mean.sd.names <- grep("-(mean|std)\\(\\)", featureslabels, value = T)
mean.sd.names <- gsub("-mean", "Mean", mean.sd.names)
mean.sd.names <- gsub("-std", "Std", mean.sd.names)
mean.sd.names <- gsub("[-()]", "", mean.sd.names)

#load train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt")[mean.sd]

#load test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")[mean.sd]

#merge data sets
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
all <- rbind(train, test)
colnames(all) <- c("subject", "activity", mean.sd.names)

#clarifying variable names
allcols <- colnames(all)
allcols  <- gsub("[\\(\\)-]", "", allcols)
allcols  <- gsub("BodyBody", "Body", allcols)
allcols <- gsub("^f", "frequencyDomain", allcols)
allcols <- gsub("^t", "timeDomain", allcols)
allcols <- gsub("Acc", "Accelerometer", allcols)
allcols <- gsub("Gyro", "Gyroscope", allcols)
allcols <- gsub("Mag", "Magnitude", allcols)
allcols <- gsub("Freq", "Frequency", allcols)
allcols <- gsub("mean", "Mean", allcols)
allcols <- gsub("std", "StandardDeviation", allcols)
colnames(all) <- allcols

#converting activity and subjects to factors
all$activity <- factor(all$activity, levels = activityid[ ,1], 
                        labels = activitylabels)
all$subject <- as.factor(all$subject)

#find mean of variables
all.melted <- melt(all, id = c("subject", "activity"))
all.mean <- dcast(all.melted, subject + activity ~ variable, mean)

#write tidy data to file
write.table(all.mean, "tidydata.txt", row.names = F, quote = F)