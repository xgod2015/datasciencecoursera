library(plyr)
#read feature.txt, it contains the description for each variable in x_test.txt & x_train.txt
feature<-read.table('./Samsung/features.txt',col.names=c('colNo','label'))
#read activity_labels.txt
act_labels<-read.table('./Samsung/activity_labels.txt',col.names=c('act_id','activity'))
#read test data set
sbj_test<-read.table('./Samsung/test/subject_test.txt',col.names=c('object'))
sbj_test$no<-seq(along=sbj_test[,1])
act_test<-read.table('./Samsung/test/y_test.txt',col.names=c("act_id"))
#merge act_test with lables
act_test<-merge(act_test,act_labels,by='act_id')
act_test$no<-seq(along=act_test[,1])
data_test<-read.table('./Samsung/test/X_test.txt',col.names=feature$label,check.names=FALSE)
data_test$no<-seq(along=data_test[,1])
#merge the test data set into one table
test<-join_all(list(sbj_test,act_test,data_test))

#read training data set
sbj_train<-read.table('./Samsung/train/subject_train.txt',col.names=c('object'))
sbj_train$no<-seq(along=sbj_train[,1])
act_train<-read.table('./Samsung/train/y_train.txt',col.names=c("act_id"))
#merge act_test with lables
act_train<-merge(act_train,act_labels,by='act_id')
act_train$no<-seq(along=act_train[,1])
data_train<-read.table('./Samsung/train/X_train.txt',col.names=feature$label,check.names=FALSE)
data_train$no<-seq(along=data_train[,1])
#merge the test data set into one table
train<-join_all(list(sbj_train,act_train,data_train))

#merge the test and train into one table
data<-rbind(test,train)

#select only the variables containing mean and std
cols<-grep('mean\\(|std',names(data))
data<-data[c(1,4,cols)]

newData<-melt(data,id=c('object','activity'))
newData<-dcast(newData,object+activity~variable,mean)
write.table(newData,'./result.txt',row.name=FALSE)