data_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
local_filename <- './project-data.zip'
unzipped_data <- './UCI HAR Dataset'
result_file <- './result-UCI-HAR-data.csv'
averages_result_file <- './averages-UCI-HAR-data.csv'

download.file(data_url, destfile = local_filename)
unzip(local_filename)

# Read "activity_labels.txt" and "features.txt".
activity_labels <- read.table(paste(unzipped_data, 'activity_labels.txt', sep = '/'), header = FALSE)
names(activity_labels) <- c('id', 'name')

features <- read.table(paste(unzipped_data, 'features.txt', sep = '/'), header = FALSE)
names(features) <- c('id', 'name')

# Read data files.
x_train <- read.table(
    paste(unzipped_data, 'train', 'X_train.txt', sep = '/'), 
    header = FALSE
)
names(x_train) <- features$name
y_train <- read.table(
  paste(unzipped_data, 'train', 'y_train.txt', sep = '/'), 
  header = FALSE
)
names(y_train) <- c('activity')
subject <- read.table(
  paste(unzipped_data, 'train', 'subject_train.txt', sep = '/'), 
  header = FALSE
)
names(subject) <- c('subject')
x_test <- read.table(
  paste(unzipped_data, 'test', 'X_test.txt', sep = '/'), 
  header = FALSE
)
names(x_test) <- features$name
y_test <- read.table(
  paste(unzipped_data, 'test', 'y_test.txt', sep = '/'), 
  header = FALSE
)
names(y_test) <- c('activity')
test_subject <- read.table(
  paste(unzipped_data, 'test', 'subject_test.txt', sep = '/'), 
  header = FALSE
)
names(test_subject) <- c('subject')

# Merge datasets.
X <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject, test_subject)

# Filter mean and std.
X <- X[, grep('mean|std', features$name)]
y$activity <- activity_labels[y$activity,]$name

# Merge datasets and write result file.
merged_data <- cbind(subject, y, X)
write.csv(merged_data, result_file)

# Compute the averages and write file.
averages_dataset <- aggregate(
  merged_data[, 3:dim(merged_data)[2]],
  list(merged_data$subject, merged_data$activity),
  mean
)
names(averages_dataset)[1:2] <- c('subject', 'activity')
write.csv(averages_dataset, averages_result_file)