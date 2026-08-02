# Overview
This repository contains a React frontend, and an Express backend that the frontend connects to.

# Objective
Deploy the frontend and backend to somewhere publicly accessible over the internet. The AWS Free Tier should be more than sufficient to run this project, but you may use any platform and tooling you'd like for your solution.

Fork this repo as a base. You may change any code in this repository to suit the infrastructure you build in this code challenge.

# Submission
1. A github repo that has been forked from this repo with all your code.
2. Modify this README file with instructions for:
* Any tools needed to deploy your infrastructure
* All the steps needed to repeat your deployment process
* URLs to the your deployed frontend.

# Evaluation
You will be evaluated on the ease to replicate your infrastructure. This is a combination of quality of the instructions, as well as any scripts to automate the overall setup process.

# Setup your environment
Install nodejs. Binaries and installers can be found on nodejs.org.
https://nodejs.org/en/download/

For macOS or Linux, Nodejs can usually be found in your preferred package manager.
https://nodejs.org/en/download/package-manager/

Depending on the Linux distribution, the Node Package Manager `npm` may need to be installed separately.

# Running the project
The backend and the frontend will need to run on separate processes. The backend should be started first.
```
cd backend
npm ci
npm start
```
The backend should response to a GET request on `localhost:8080`.

With the backend started, the frontend can be started.
```
cd frontend
npm ci
npm start
```
The frontend can be accessed at `localhost:3000`. If the frontend successfully connects to the backend, a message saying "SUCCESS" followed by a guid should be displayed on the screen.  If the connection failed, an error message will be displayed on the screen.

# Configuration
The frontend has a configuration file at `frontend/src/config.js` that defines the URL to call the backend. This URL is used on `frontend/src/App.js#12`, where the front end will make the GET call during the initial load of the page.

The backend has a configuration file at `backend/config.js` that defines the host that the frontend will be calling from. This URL is used in the `Access-Control-Allow-Origin` CORS header, read in `backend/index.js#14`

# Optional Extras
The core requirement for this challenge is to get the provided application up and running for consumption over the public internet. That being said, there are some opportunities in this code challenge to demonstrate your skill sets that are above and beyond the core requirement.

A few examples of extras for this coding challenge:
1. Dockerizing the application
2. Scripts to set up the infrastructure
3. Providing a pipeline for the application deployment
4. Running the application in a serverless environment

This is not an exhaustive list of extra features that could be added to this code challenge. At the end of the day, this section is for you to demonstrate any skills you want to show that’s not captured in the core requirement.

# My Implementation

## Project Overview

This project deploys a Dockerized React frontend and Express backend application to AWS using Terraform and Amazon ECS with AWS Fargate. The infrastructure includes a custom VPC, public and private subnets, an Internet Gateway, NAT Gateway, Application Load Balancer (ALB), Amazon ECR repositories, IAM roles, security groups, auto scaling, and a Jenkins master server for CI/CD. The application was validated through functional testing and load testing using Siege.

## Prerequisites

Before deploying the infrastructure, install and configure the following tools:

- Git
- Docker Desktop
- Node.js and npm
- AWS CLI
- Terraform
- Visual Studio Code
- Jenkins
- Siege (for load testing)

Configure the AWS CLI with your AWS credentials:

```bash
aws configure
```

Verify the configuration:

```bash
aws sts get-caller-identity
```

## Deployment Instructions

### 1. Clone the Repository

```bash
git clone <your-github-repository-url>
cd <repository-name>
```

### 2. Build the Docker Images

Build the backend image:

```bash
cd backend
docker build -t backend-app .
```

Build the frontend image:

```bash
cd ../frontend
docker build -t frontend-app .
```

### 3. Configure AWS

Configure your AWS credentials:

```bash
aws configure
```

Verify the credentials:

```bash
aws sts get-caller-identity
```

### 4. Deploy the Infrastructure

Initialize Terraform:

```bash
terraform init
```

Format the Terraform configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted to create the AWS resources.

## Terraform Infrastructure

Terraform provisions the following AWS resources:

- Virtual Private Cloud (VPC)
- Two public subnets across multiple Availability Zones
- Two private subnets across multiple Availability Zones
- Internet Gateway
- NAT Gateway
- Route tables and subnet associations
- Amazon ECS Cluster using AWS Fargate
- Amazon Elastic Container Registry (ECR) repositories
- Application Load Balancer (ALB)
- Target Groups and Listener Rules
- IAM roles and policies for ECS tasks
- Security Groups
- Jenkins EC2 instance
- Auto Scaling policies for ECS services
- CloudWatch log groups

## Jenkins Setup

A Jenkins master server was provisioned using Terraform on an Amazon EC2 instance running Amazon Linux 2023.

The Jenkins server was configured with:

- Amazon Linux 2023 AMI
- t3.small EC2 instance
- 30 GB encrypted GP3 root volume
- Elastic IP address
- Dedicated Jenkins Security Group
- HTTP (80), HTTPS (443), SSH (22), and Jenkins (8080) ports enabled

After deployment, Jenkins can be accessed using:

```
http://<jenkins-public-ip>:8080
```

The initial administrator password can be retrieved from the Jenkins server after installation to complete the setup process.

## Scaling Results

Load testing was performed using Siege to evaluate the application's performance through the Application Load Balancer.

### Load Test Configuration

- Tool: Siege
- Concurrent Users: 250
- Test Duration: 2 minutes

Command used:

```bash
siege -c 250 -t 2M http://devops-challenge-alb-1896968655.us-east-2.elb.amazonaws.com
```

### Results

| Metric | Result |
|---------|--------|
| Transactions | 19,277 |
| Availability | 99.64% |
| Elapsed Time | 120.78 seconds |
| Data Transferred | 206.11 MB |
| Response Time | 1.40 seconds |
| Transaction Rate | 159.60 transactions/second |
| Throughput | 1.71 MB/second |
| Concurrency | 223.11 |
| Successful Transactions | 19,277 |
| Failed Transactions | 69 |
| Longest Transaction | 19.51 seconds |
| Shortest Transaction | 0.11 seconds |

The results demonstrate that the application remained highly available under a sustained load of 250 concurrent users. During the two-minute test, the infrastructure processed over 19,000 requests with 99.64% availability while maintaining an average response time of 1.40 seconds, indicating that the ECS Fargate services and Application Load Balancer handled the workload effectively.