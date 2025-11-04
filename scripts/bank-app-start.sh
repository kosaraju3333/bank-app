#!/bin/bash

#########################################################################
#									#
# This Script will perform 2 operations.				#
# 	1) Fetch DB Secrets from AWS Secrets Manager and export as env 	#
# 	2) Download bank app jar file from AWS S3 and start the  app	#
#									#
#########################################################################

# declared variable working_dir and assign work directory path
working_dir=/home/ubuntu/bank-app

# Creat /home/ubuntu/portal-spontansolutions directory if not present
if [ -d "$working_dir" ];
then
echo "$working_dir is already exist"
else
echo "********** creating $working_dir directory **********"
mkdir $working_dir
fi

# Fetch DB secrets from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value   --secret-id prod/bankapp/mysql   --query SecretString --output text)

# Export as environment variables
export DB_USERNAME=$(echo $SECRET_JSON | jq -r '.dbuser')
export DB_PASSWORD=$(echo $SECRET_JSON | jq -r '.dbpassword')

# Download bank app artifactory from AWS S3
echo "********** Downloading bank app artifactory from AWS S3 **********"
aws s3 cp s3://spontansolutions/bank-app/bankapp-0.0.1-SNAPSHOT.jar $working_dir

# Start the Bank app up from jar
echo "********** Staring  bank app service from jar **********"
exec /usr/bin/java -jar /home/ubuntu/bank-app/bankapp-0.0.1-SNAPSHOT.jar >> /var/log/bank-app/app.log 2>&1
#bash -c 'nohup java -jar /home/ubuntu/bank-app/bankapp-0.0.1-SNAPSHOT.jar >> /var/log/bank-app/app.log 2>&1 &'