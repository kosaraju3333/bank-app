# bankapp
bank application

#MYSQL

`docker run -id -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=Test@123" -e "MYSQL_DATABASE=bankappdb" --name mysql_c1 mysql:8`

#How to set system environment variables in applicaton.properties the 12 factor way?
`https://stackoverflow.com/questions/42426438/how-to-set-system-environment-variables-in-applicaton-properties-the-12-factor-w`

🚀 Production-Ready Java Spring Boot Application on AWS (CI/CD with CodePipeline, CodeBuild, CodeDeploy)

This repository contains a monolithic Java Spring Boot application (frontend + backend + MySQL) deployed on AWS using a fully automated CI/CD pipeline built with CodePipeline, CodeBuild, and CodeDeploy.

🏗️ Architecture Overview

This setup follows a 3-tier architecture pattern:

Tier	Component	Description
Presentation	Java Spring Boot Frontend	Exposed via AWS ALB (HTTPS)
Application	Java Spring Boot Backend	Deployed on EC2 behind Auto Scaling Group
Database	MySQL (RDS)	Hosted in private subnet with SSL and Secrets Manager integration
🌐 Infrastructure Setup
1. Networking (VPC Setup)

Created a dedicated VPC.

Attached Internet Gateway for public internet access.

Created 4 subnets:

2 Public subnets in us-east-1a and us-east-1b.

2 Private subnets in us-east-1a and us-east-1b.

Configured Public Route Table:

Added route 0.0.0.0/0 → Internet Gateway (IGW)

Configured NAT Gateway in one public subnet.

Configured Private Route Table:

Added route 0.0.0.0/0 → NAT Gateway

2. Database Layer

Created RDS MySQL instance in private subnet.

Enabled Multi-AZ for high availability.

Configured endpoint under Private Hosted Zone:

bank-db.spontansolutions.com


Enabled Encryption at Rest (KMS) and Encryption in Transit (SSL/TLS).

Stored DB credentials securely in AWS Secrets Manager.

3. Compute Layer (Application Tier)

Created Target Group with HTTP protocol.

Created Launch Template with:

Pre-baked AMI (with CodeDeploy agent and app systemd service)

Instance type (t3.medium)

IAM instance profile

Key pair for SSH access

Created Auto Scaling Group (ASG) in private subnets.

Attached ASG to Target Group.

Created Internet-facing ALB:

Listener on port 443 (HTTPS) → Target Group

Listener on port 80 (HTTP) → Redirects to HTTPS

ALB DNS name mapped to:

bank-app.spontansolutions.com

🧩 Additional Production-Ready Integrations
1️⃣ VPC Gateway Endpoint for S3

Configured S3 Gateway Endpoint to allow EC2 → S3 traffic within AWS network.

Ensures build artifacts are downloaded securely without leaving AWS.

2️⃣ VPC Interface Endpoint for Secrets Manager

Configured Secrets Manager Interface Endpoint for EC2 → Secrets Manager communication.

Used to fetch DB credentials and app secrets at runtime securely.

3️⃣ Outbound Access for CodeDeploy

Created NAT Gateway for EC2 instances to access AWS CodeDeploy API.

(Note: CodeDeploy VPC Endpoint is not supported, hence NAT required.)

⚙️ CI/CD Pipeline Setup
🧱 1. AWS CodePipeline

Source: GitHub repository (triggered via webhook on every push to main branch).

Stages:

Source → Fetch latest code from GitHub.

Build → Trigger CodeBuild to build and package app.

Deploy → Trigger CodeDeploy Blue/Green deployment.

🧩 2. AWS CodeBuild

Uses buildspec.yaml file to:

Build the Spring Boot JAR.

Run unit tests.

Package artifacts.

Upload to S3 for CodeDeploy.

IAM permissions for:

S3 upload.

CodePipeline artifact access.

Secrets Manager.

🚀 3. AWS CodeDeploy (Blue-Green Deployment)

Configured Blue/Green Deployment Strategy:

Old ASG = Blue Environment.

New ASG = Green Environment.

Traffic shifted via ALB listener rules.

Automatic rollback on failure.

Lifecycle hooks for:

BeforeInstall → Stop old app/systemd service.

AfterInstall → Start new app version.

AfterAllowTraffic → Verify deployment health.

🧰 IAM Configuration

CodePipeline IAM Role → Permissions for CodeBuild, CodeDeploy, S3.

CodeBuild IAM Role → Permissions for S3, Secrets Manager, CloudWatch Logs.

CodeDeploy IAM Role → Permissions to manage EC2, ASG, ALB traffic shifting.

EC2 Instance Role → Permissions for:

S3 access (download artifacts)

Secrets Manager access (DB credentials)

CloudWatch logs

🔒 Security Best Practices Implemented

✅ ALB with HTTPS (SSL termination using AWS ACM certificate)
✅ Private subnets for app servers and database
✅ Secrets Manager for credentials
✅ VPC Endpoints to avoid public data transfer
✅ IAM least-privilege access
✅ Encrypted RDS and S3
✅ Blue-Green deployment for zero downtime

📊 Monitoring & Logging

Amazon CloudWatch for application and system logs.

CloudWatch Alarms for CPU utilization and instance health.

ALB Access Logs stored in S3.

RDS Performance Insights enabled.

🧾 Deployment Flow Summary
graph TD;
A[GitHub Push] --> B[CodePipeline Trigger]
B --> C[CodeBuild - Build & Upload Artifact to S3]
C --> D[CodeDeploy - Blue/Green Deployment]
D --> E[Auto Scaling Group - Launch New Instances]
E --> F[ALB - Shift Traffic to New Version]
F --> G[Monitoring & Rollback if Failure]

📁 Repository Structure
├── src/                       # Java source code
├── buildspec.yaml              # Build instructions for CodeBuild
├── appspec.yml                 # Deployment instructions for CodeDeploy
├── scripts/
│   ├── app-start.sh
│   ├── app-stop.sh
│   └── app-restart.sh
└── README.md                   # Documentation

🧪 Blue/Green Deployment Verification

Validate old ASG → Blue

New ASG launched → Green

ALB target group health check → Healthy ✅

Traffic shifted to Green

Blue ASG automatically terminated after successful deployment

🧠 Future Enhancements

Integrate SonarQube for code quality analysis

Add Trivy for container security scanning

Implement Slack notifications via AWS SNS for deployment events

Add Prometheus + Grafana for metrics visualization

👤 Author

Ramakrishna — AWS DevOps Engineer
Expertise in AWS, Jenkins, CodePipeline, Terraform, EKS, ArgoCD, and DevSecOps automation.