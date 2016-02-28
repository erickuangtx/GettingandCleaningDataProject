
# read data set
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')


y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')

subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')

#1.  Merges the training and the test sets to create one data set. (still separately for x, y, and subject)

x<-rbind(x_train, x_test)
y<-rbind(y_train, y_test)
subject<-rbind(subject_train,subject_test )



#2. Extracts only the measurements on the mean and standard deviation for each measurement.

  features <- read.table('./UCI HAR Dataset/features.txt')

  mean_sd_index <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

    #only keep the measurements that has "mean" and "std" in its names 

      x<-x[,mean_sd_index]

#3.  Uses descriptive activity names to name the activities in the dataset

    # read activity labels
    activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
    activities[,2]<-tolower(gsub("_", "",activities[,2] ))
    
    #replace the column in y dataframe, which holds the activity info for the measurement
    y[, 1] = activities[y[, 1], 2]
    
    colnames(y)<-"activity"
    
   

#4. Appropriately labels the data set with descriptive variable names.
    
    # clean up the measurement dataframe:
    
    names(x)<-features[mean_sd_index, 2]
    names(x)<-tolower(gsub("\\(|\\)", "", names(x)))
    
    # no. of volunteers
    
    colnames(subject)<-"subject"
    
    #combine subject, x and y to form one dataset, with labels all appropriately treated:
    
    result<-cbind(x, y, subject)
    
    #save the dataset into result.txt
    write.table(result, 'result.txt', row.names = F)

#5. From the data set in step 4, creates a second, independent tidy data set 
    ##with the average of each variable for each activity and each subject.
    average <- aggregate(x=result, by=list(activities=result$activity, subjects=result$subject), FUN=mean)
    ##delete the rightest two columns:
    average <- average[, 1:68]
    
    write.table(average, 'average.txt', row.names = F)
    
    

    
    
