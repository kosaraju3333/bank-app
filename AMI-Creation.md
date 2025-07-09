# Java Bank Application – AMI Creation Guide

This document outlines the steps taken to create a custom Amazon Machine Image (AMI) for deploying the Java-based Bank Application in a production-grade setup on AWS EC2.

---

## 📌 Step 1: AMI Creation – Java App Base Image

### ✅ Purpose
The goal is to create a reusable AMI that comes pre-installed with:
- Java JDK 17
- AWS CLI
- Java Bank Application startup script
- Systemd service for automatic app startup on instance boot

---

### 🔧 Software Installation & Configuration

#### 1. Install Java JDK 17
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

### 2. Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

🛠️ App Startup Script:

Create a startup script to run the Java Bank App.

📁 Path:
/opt/bank-app-start.sh

📜 Sample Script:
```bash
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
```
Make it executable:
chmod +x /opt/bank-app-start.sh


