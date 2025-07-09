#!/bin/bash


#Downloading bank app jar from AWS S3 and starting app

working_dir=/home/ubuntu/bank-app

#Creating /home/ubuntu/portal-spontansolutions directory if not present

if [ -d "$working_dir" ];
then
echo "$working_dir is already exist"
else
echo "********** creating $working_dir directory **********"
mkdir $working_dir
fi

#Downloading bank app artifactory from AWS S3

echo "********** Downloading bank app artifactory from AWS S3 **********"
aws s3 cp s3://bank-app-spontansolutions/bankapp-0.0.1-SNAPSHOT.jar $working_dir

#Starting the Bank app up from jar

echo "********** Staring  bank app service from jar **********"
exec /usr/bin/java -jar /home/ubuntu/bank-app/bankapp-0.0.1-SNAPSHOT.jar >> /var/log/bank-app/app.log 2>&1
#bash -c 'nohup java -jar /home/ubuntu/bank-app/bankapp-0.0.1-SNAPSHOT.jar >> /var/log/bank-app/app.log 2>&1 &'
