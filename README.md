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
