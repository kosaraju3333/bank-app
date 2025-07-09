# Java Bank Application – Deployment Guide


## 📌 Step 1: AMI Creation – Java App Base Image

This section outlines the steps taken to create a custom Amazon Machine Image (AMI) for deploying the Java-based Bank Application in a production-grade setup on AWS EC2.

### ✅ Purpose
The goal is to create a reusable AMI that comes pre-installed with:
- Java JDK 17
- AWS CLI
- Java Bank Application startup script
- Systemd service for automatic app startup on instance boot

### 🔧 Software Installation & Configuration

#### 1. Install Java JRE 17
```bash
sudo apt update
sudo apt install -y openjdk-17-jre
java -version
```

#### 2. Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### 🛠️ App Startup Script:

Create a startup script to run the Java Bank App.

📁 Path:
/opt/bank-app-start.sh

📜 Script:
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

`chmod +x /opt/bank-app-start.sh`

### ⚙️ Configure systemd Service
📁 Location:
/etc/systemd/system/bankapp.service

📜 Service File:
```bash
[Unit]
Description=Bank App Service
After=network.target

[Service]
User=root
WorkingDirectory=/opt
ExecStart=/opt/bank-app-start.sh

Restart=on-failure
RestartSec=5
SuccessExitStatus=143

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```
Enable, start and check status of the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable bankapp.service
sudo systemctl start bankapp.service
sudo systemctl status bankapp.service
```

### 🖼️ Create the AMI
Once everything is working as expected:

1. Stop the EC2 instance (optional, recommended).

2. In the AWS Console:

   *  Go to EC2 → Instances → Select your instance

   *  Click Actions → Image → Create Image

   *  Provide a name like java-bankapp-ami and description

   *  Create the AMI

### ✅ Outcome
You now have a reusable AMI with:

  *  Java 17 runtime

  *  AWS CLI pre-installed (To access the AWS S3 bucket to download the java jar (artifact)

  * Java app bootstrapped via systemd

This AMI can be used in auto-scaling groups, launch templates, or EC2-based deployments for consistent infrastructure.

---

## 🚀 Step 2: Deploy EC2 Instance from Custom AMI

This section describes how to launch a production-ready EC2 instance using the custom AMI created in [Step 1](#-step-1-ami-creation--java-app-base-image).


### ✅ Launch EC2 from AMI

1. **Go to AWS Console** → **EC2** → **Instances** → **Launch Instance**.
2. **Name** your instance:  
   Example: `bank-app-prod-server`
3. Under **Application and OS Images (Amazon Machine Image)**:
   - Click **My AMIs** tab.
   - Select your custom AMI (`java-bankapp-ami`).
4. Choose an **Instance Type** (e.g., `t3.micro` or `t3.medium` for production).
5. Choose or create a **Key Pair** for SSH access.
6. **Network Settings**:
   - Assign a public IP (if accessing from the internet).
   - Attach it to an existing **VPC and Subnet**.
   - Open **port 80** and **port 443** (for HTTP/HTTPS).
7. Click **Launch Instance**.

### 🔍 Verify Application Is Running

Once the instance is launched:

```bash
# SSH into the instance
ssh -i <your-key.pem> ubuntu@<your-public-ip>

# Check if the service is running
sudo systemctl status bankapp.service

# Tail logs if needed
tail -f /var/log/bank-app/app.log
```
`Visit http://<your-public-ip> in your browser to see the Java Bank App in action.`

---

## 🌐 Step 3: Set Up Load Balancer, Domain, and SSL

This step guides you through exposing your Java Bank App to the internet using an **Application Load Balancer (ALB)**, **Route 53 custom domain**, and **SSL certificates** for HTTPS.


### ✅ Create an Application Load Balancer (ALB)

1. Go to **EC2 → Load Balancers → Create Load Balancer**
2. Select **Application Load Balancer**
3. **Name** your load balancer (e.g., `bank-app-alb`)
4. **Scheme**: internet-facing
5. **Listeners**:
   - Add HTTP (port 80)
   - Add HTTPS (port 443) if using SSL
6. **Availability Zones**: Select at least 2 subnets

### 🔀 Create a Target Group

1. Choose **Instances** as the target type
2. Name: `bank-app-tg`
3. Protocol: **HTTP**, Port: **80**
4. Register your EC2 instance running the Bank App
5. Health check path: `/` (or your app health endpoint)

### 🔗 Attach Target Group to Load Balancer

1. In **Load Balancer Listener Rules**, forward HTTP/HTTPS to the `bank-app-tg` target group
2. Save and review

### 🌍 Configure Custom Domain with Route 53 (Optional)

1. Go to **Route 53 → Hosted Zones → Create Hosted Zone**
   - Domain: `yourdomain.com`
2. Add an **A Record**:
   - Type: A (Alias)
   - Alias to: your ALB DNS name
3. Update your domain's DNS provider to use Route 53 nameservers

### 🔒 Enable SSL with AWS ACM

1. Go to **AWS Certificate Manager (ACM)** → **Request a Public Certificate**
2. Add domain name(s): `yourdomain.com`, `www.yourdomain.com`
3. Choose **DNS validation**
4. Once validated, go to **Load Balancer → Listeners → HTTPS (443)**
   - Edit and attach your new SSL certificate
   - Forward to your target group

### 🧪 Test Your Setup

- Visit: `https://yourdomain.com` or `https://<ALB-DNS-name>`
- You should see your Java Bank App running securely behind the load balancer

---
