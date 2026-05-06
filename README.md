# AWS EC2 Automation & Troubleshooting Lab

## Project Overview
This lab involved provisioning scalable infrastructure on AWS using both manual and automated methods.

## Technical Tasks Accomplished:
* **Manual Provisioning:** Launched a Bastion Host using the AWS Management Console to act as a secure gateway.
* **Automated Deployment:** Utilized the AWS CLI to launch a Web Server with a `UserData` script to automate Apache installation.
* **Security Group Configuration:** Resolved connectivity issues by modifying inbound security rules (Port 22/80).
* **Service Remediation:** Diagnosed and restarted inactive `httpd` services via the Linux terminal.

## Key AWS Services Used:
* Amazon EC2
* AWS CLI
* IAM Roles & Instance Profiles
* VPC (Public Subnets & Security Groups)
