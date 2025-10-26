# Infrastructure as Code with Terraform - AWS EC2

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

A beginner-friendly Infrastructure as Code (IaC) project using Terraform to provision and manage AWS EC2 instances with proper security configurations.

## 📋 Project Overview

This project demonstrates the fundamentals of Infrastructure as Code using Terraform. It automates the creation of an AWS EC2 instance with:
- SSH key pair authentication
- Security group with ingress/egress rules
- Public IP address access
- Proper network configuration using default VPC

**Project URL**: [roadmap.sh/projects/iac-digitalocean](https://roadmap.sh/projects/iac-digitalocean)  
**Repository**: [github.com/RushikeshGhodke/iac-aws-terraform](https://github.com/RushikeshGhodke/iac-aws-terraform)

## 🎯 Learning Objectives

- Understand Infrastructure as Code (IaC) principles
- Learn Terraform syntax and resource management
- Configure AWS EC2 instances programmatically
- Implement security best practices with security groups
- Manage SSH key pairs for secure server access

## 🏗️ Architecture

```
┌────────────────────────────────────────┐
│        AWS Cloud (default VPC)         │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │   Security Group (terraform_sg)  │  │
│  │  ┌────────────────────────────┐  │  │
│  │  │  Ingress Rules:            │  │  │
│  │  │  - SSH (22)                │  │  │
│  │  │  - HTTP (80)               │  │  │
│  │  │  - HTTPS (443)             │  │  │
│  │  │  - Node.js App (3000)      │  │  │
│  │  └────────────────────────────┘  │  │
│  │                                  │  │
│  │  ┌────────────────────────────┐  │  │
│  │  │  EC2 Instance              │  │  │
│  │  │  - Type: t2.micro          │  │  │
│  │  │  - AMI: Ubuntu             │  │  │
│  │  │  - Storage: 10GB gp3       │  │  │
│  │  │  - Public IP: Yes          │  │  │
│  │  └────────────────────────────┘  │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

## 📦 Resources Created

| Resource | Type | Description |
|----------|------|-------------|
| `aws_key_pair.iac-key` | SSH Key Pair | Authentication for EC2 access |
| `aws_default_vpc.default_vpc` | VPC | Uses AWS default VPC |
| `aws_security_group.terraform_sg` | Security Group | Network access control |
| `aws_security_group_rule.ssh` | Ingress Rule | SSH access (port 22) |
| `aws_security_group_rule.http` | Ingress Rule | HTTP access (port 80) |
| `aws_security_group_rule.https` | Ingress Rule | HTTPS access (port 443) |
| `aws_security_group_rule.node_app` | Ingress Rule | Node.js app (port 3000) |
| `aws_security_group_rule.egress_all` | Egress Rule | All outbound traffic |
| `aws_instance.terraform_ec2` | EC2 Instance | t2.micro compute instance |

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) (v1.0+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- AWS Account with appropriate permissions
- SSH key pair generated

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/RushikeshGhodke/iac-aws-terraform.git
   cd iac-aws-terraform
   ```

2. **Generate SSH Key Pair**
   ```bash
   ssh-keygen -t rsa -b 4096 -f terra-key -N ""
   ```
   This creates:
   - `terra-key` (private key - keep secure!)
   - `terra-key.pub` (public key - used by Terraform)

3. **Configure AWS Credentials**
   ```bash
   aws configure
   ```
   Enter your:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., `us-east-1`)
   - Output format (e.g., `json`)

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Validate Configuration**
   ```bash
   terraform validate
   ```

6. **Preview Changes**
   ```bash
   terraform plan
   ```

7. **Apply Configuration**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

8. **Get EC2 Public IP**
   ```bash
   terraform output
   ```
   Or check the AWS Console.

9. **Connect via SSH**
   ```bash
   ssh -i terra-key ec2-user@<EC2_PUBLIC_IP>
   ```

## 📁 Project Structure

```
iac-aws/
├── ec2.tf                      # Main EC2 and security configuration
├── providers.tf                # AWS provider configuration
├── localfilecreation.tf        # Local file operations (if any)
├── terra-key                   # Private SSH key (DO NOT COMMIT)
├── terra-key.pub               # Public SSH key
├── terraform.tfstate           # Terraform state file (DO NOT COMMIT)
├── terraform.tfstate.backup    # State backup
├── .terraform.lock.hcl         # Dependency lock file
└── .terraform/                 # Terraform plugins directory
```

## 🔧 Configuration Details

### Security Group Rules

| Port | Protocol | Source | Description |
|------|----------|--------|-------------|
| 22 | TCP | 0.0.0.0/0 | SSH access |
| 80 | TCP | 0.0.0.0/0 | HTTP traffic |
| 443 | TCP | 0.0.0.0/0 | HTTPS traffic |
| 3000 | TCP | 0.0.0.0/0 | Node.js application |
| All | All | 0.0.0.0/0 | Outbound (egress) |

### EC2 Instance Specifications

- **AMI**: `ami-0bc691261a82b32bc` (Amazon Linux 2023)
- **Instance Type**: `t2.micro` (Free tier eligible)
- **Storage**: 10GB gp3 SSD
- **Key Pair**: `terra-key`
- **Region**: Configured in AWS provider

## 🛡️ Security Best Practices

⚠️ **Important Security Notes:**

1. **Never commit sensitive files:**
   ```bash
   # Add to .gitignore
   terra-key
   terra-key.pub
   *.tfstate
   *.tfstate.backup
   .terraform/
   ```

2. **Restrict SSH access in production:**
   ```hcl
   cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Instead of 0.0.0.0/0
   ```

3. **Use environment variables for AWS credentials:**
   ```bash
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"
   ```

4. **Enable AWS CloudTrail** for audit logging

5. **Use IAM roles** for EC2 instead of hardcoded credentials

## 🧹 Cleanup

To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted. This will remove:
- EC2 instance
- Security group and rules
- SSH key pair


## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Rushikesh Ghodke**

- GitHub: [@RushikeshGhodke](https://github.com/RushikeshGhodke)
- Project Link: [iac-aws-terraform](https://github.com/RushikeshGhodke/iac-aws-terraform)


**⚡ Pro Tips:**

- Use `terraform fmt` to format your code
- Use `terraform plan -out=tfplan` to save execution plans
- Enable [Terraform Cloud](https://app.terraform.io/) for remote state management
- Consider using [tfenv](https://github.com/tfutils/tfenv) for Terraform version management