# 🏦 Secure Banking Application on AWS — DevSecOps CI/CD & Cloud Architecture

## 📘 Project Overview
This project demonstrates a **secure, scalable, and production-ready 3-tier architecture** for a **Java Spring Boot Banking Application**, fully deployed on **AWS** using a **DevSecOps CI/CD pipeline** with **GitHub Actions**, **AWS CodeDeploy**, and a **Blue-Green Deployment** strategy.

The design follows AWS best practices for **network isolation**, **data encryption**, and **automated deployments** — providing a true enterprise-grade setup.

---

## 🏗️ AWS Architecture Overview

### 🔹 Key Components

| Tier | AWS Service | Description |
|------|--------------|-------------|
| **Presentation Layer** | **Amazon CloudFront** | CDN for global content delivery and DDoS protection |
|  | **Application Load Balancer (ALB)** | Internet-facing load balancer with HTTPS (SSL termination using ACM) |
   | **Route 53** | Route 53 provides DNS resolution |
| **Application Layer** | **EC2 Auto Scaling Group (ASG)** | Hosts the Java Spring Boot app in private subnets for scalability and high availability |
|  | **AWS CodeDeploy (Blue-Green)** | Automates deployments and ensures zero downtime |
| **Data Layer** | **Amazon RDS (MySQL)** | Encrypted relational database instance in private subnet |

---

## 🔒 Network & Security Design

### 🕸️ **VPC Configuration**
- **Public Subnets**: Contain the ALB and NAT Gateway  
- **Private Subnets**: Contain EC2 instances, RDS, and VPC Endpoints  
- **Routing**:
  - Private subnets route through **NAT Gateway** to access AWS APIs
  - **VPC Endpoints** ensure private connectivity to S3 and Secrets Manager
 
### 🔑 **VPC Endpoints**
| Endpoint Type | Service | Purpose |
|----------------|----------|----------|
| **Gateway Endpoint** | Amazon S3 | Allows EC2 instances in private subnets to securely download build artifacts (JARs) |
| **Interface Endpoint** | AWS Secrets Manager | Enables secure access to secrets without exposing traffic to the internet |

### 🔐 **Security Groups**
| Resource | Allowed Ports | Source | Purpose |
|-----------|----------------|--------|----------|
| **ALB SG** | 80, 443 | 0.0.0.0/0 | Public web access |
| **EC2 App SG** | 5050 | ALB SG | Application traffic from ALB |
|  | 22 | Bastion/Private subnet only | Restricted SSH access |
| **RDS SG** | 3306 | EC2 App SG | DB connections only from application instances |

All security groups follow the **principle of least privilege** and ensure tight network isolation.

---

## 🧱 Data Encryption & Security

### 🛡️ **At-Rest Encryption**
| Resource | KMS Key | Description |
|-----------|----------|-------------|
| **EC2 EBS Volumes** | `aws/ebs` | Automatically encrypted using AWS-managed KMS key. Data written to or read from the disk is transparently encrypted/decrypted by AWS. |
| **RDS MySQL** | `aws/rds` | All database storage, backups, and snapshots are encrypted using AWS-managed KMS key. Decryption is automatic during read operations. |

> Both services (EBS and RDS) use **AWS-managed keys**, providing strong encryption without requiring custom KMS permissions or key management overhead.

### 🧩 **In-Transit Encryption**
- SSL/TLS enabled for:
  - **Application Load Balancer (HTTPS on port 443)**  
  - **CloudFront to ALB communication (HTTPS)**

### 🔐 **Secrets Management**
- Application secrets (DB credentials, tokens) are stored securely in **AWS Secrets Manager**.
- EC2 instances access secrets privately through the **VPC Interface Endpoint**.

---

### **Route 53 DNS Management**
To enable clean domain-based access and internal resolution:
- **Public Hosted Zone:**
  - Record: `bank.spontansolutions.com`
  - Target: **CloudFront Distribution DNS**
  - Purpose: Public users access the application via HTTPS endpoint `https://bank.spontansolutions.com`
- **Private Hosted Zone:**
  - Record: `bank-db.spontansolutions.com`
  - Target: **RDS MySQL Endpoint**
  - Purpose: Private DNS resolution for EC2 application servers to securely access the RDS database within the VPC.

---

## 💻 Application Overview
A **Java Spring Boot Banking Application** that provides essential banking operations with secure user authentication and persistent storage.

### 🧠 Core Features
- 👤 User Registration & Login
- 💰 Deposit & Withdraw Funds
- 🔁 Transfer Between Accounts
- 📜 View Transaction History
- 🧾 Database persistence with RDS MySQL

All sensitive data and transactions are encrypted and handled securely.

---

## ⚙️ DevSecOps CI/CD Pipeline

### 🚀 **Pipeline Stages (GitHub Actions)**

| Phase | Tool | Description |
|--------|------|-------------|
| **Pre-Build** | Trivy | Vulnerability and security scan of source code |
|  | SonarQube | Static code analysis & quality gates |
| **Build** | Maven | Compile, test, and package JAR artifact |
| **Artifact Storage** | AWS S3 | Stores packaged JAR artifact for deployment |
| **Deployment** | AWS CodeDeploy | Blue-Green deployment to EC2 Auto Scaling Group |
| **Notification** | Slack | Real-time build and deployment status |

> Pipeline defined in `.github/workflows/devsecops.yml`, triggered on code push to `main`.

---

## 🧰 Tech Stack

| Category | Tool |
|-----------|------|
| **Language** | Java 17 |
| **Framework** | Spring Boot |
| **Build Tool** | Maven |
| **CI/CD** | GitHub Actions + AWS CodeDeploy |
| **Security** | Trivy, SonarQube, AWS Secrets Manager |
| **Storage** | AWS S3 |
| **Database** | Amazon RDS (MySQL) — Encrypted with `aws/rds` |
| **Compute** | EC2 (Private Subnet) — Volumes encrypted with `aws/ebs` |
| **Networking** | VPC, NAT Gateway, VPC Endpoints |
| **Load Balancing** | AWS ALB |
| **Caching & CDN** | AWS CloudFront |
| **Monitoring** | CloudWatch, CodeDeploy Metrics |
| **Notifications** | Slack |

---

## 📈 High-Level Architecture Diagram

Supporting Services:
- VPC Endpoints → S3, Secrets Manager  
- NAT Gateway → Outbound AWS API access  
- IAM Roles → Least privilege for EC2 & CodeDeploy  
- GitHub Actions → Automated CI/CD pipeline  

---

## 🔐 Security Best Practices Implemented
- ✅ **Private subnets** for EC2, RDS, and endpoints  
- ✅ **Encryption at rest** using `aws/ebs` and `aws/rds`  
- ✅ **Encryption in transit** (SSL/TLS everywhere)  
- ✅ **Least privilege IAM roles** and SG design  
- ✅ **VPC Endpoints** for private S3 and Secrets Manager access  
- ✅ **No direct internet exposure** for app or database  
- ✅ **Trivy & SonarQube** scans in CI pipeline  
- ✅ **Slack notifications** for CI/CD transparency  

---



