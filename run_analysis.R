#Getting-and-Cleaning-Data-Project

# reshape2 used for melt and dcast functions.
install.packages("reshape2")
library(reshape2)

# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: List of all features
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# part2 (Extracts only the featurenames on the mean and standard deviation for each measurement. )
extract_features <- grepl("mean|std", features)

# Load and process X_test, y_test and subject_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Assigning List of all features as column names for x_test
names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement for X_test.
X_test = X_test[,extract_features]

# setting y_test with column names Activity_ID, Activity_Label and its corresponding values. 
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

#setting column name of subject_test for X_test
names(subject_test) = "subject"

# Column Bind test_data
test_data <- cbind(as.data.frame(subject_test), y_test, X_test)

# Load and process X_train, y_train and subject_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#setting column name of subject_test for X_train
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement for X_train.
X_train = X_train[,extract_features]

#setting y_train with column names Activity_ID, Activity_Label and its corresponding values.
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")

#setting column name of subject_test
names(subject_train) = "subject"

# Column Bind train_data
train_data <- cbind(as.data.frame(subject_train), y_train, X_train)

# row bind of test and train data
data = rbind(test_data, train_data)


id_labels   = c("subject", "Activity_ID", "Activity_Label")

# to filter out the column names except the ones in id_labels
data_labels = setdiff(colnames(data), id_labels)

# melt the data to long format to set columns in data_labels in variable column.
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# cast melt_data, Apply mean function to dataset using dcast function (to get data for subject + Activity_Label combination)
# Discarding Activity ID
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# to write the tidy_data into tidy_data.txt
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)