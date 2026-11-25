# IE-DevInfra Capstone

A collection of 24 standalone, hands-on labs for practicing infrastructure as code, cloud operations, Linux and Windows administration, containers, CI/CD, and monitoring.

The labs are designed for trainees and trainers to build practical skills on disposable AWS accounts and local or virtualized systems. Each lab includes its own implementation files, expected deliverables, verification steps, and cleanup instructions.

> [!WARNING]
> Never enable inbound TCP or UDP ports `22` (SSH) or `3389` (RDP), including temporarily or from a private network or an individual IP address.

## Contents

- [Skills covered](#skills-covered)
- [Quick start](#quick-start)
- [Project catalog](#project-catalog)
- [Repository structure](#repository-structure)
- [Evidence and deliverables](#evidence-and-deliverables)
- [Safety and cost control](#safety-and-cost-control)
- [Cleanup](#cleanup)

## Skills covered

- Amazon Web Services and Infrastructure as Code with Terraform
- EC2, S3, IAM, CloudWatch, ECR, EKS, and Elastic Load Balancing
- Linux permissions and Windows Server administration
- GitHub, pull request reviews, branch protection, and GitHub Actions
- Docker, Kubernetes, Ansible, DNS, TLS, and HTTPS
- System monitoring, backup, lifecycle management, and incident recovery

### General

- Git
- A code editor
- A disposable AWS account and repository for cloud labs
- A Bash-compatible shell or PowerShell

### Project-specific tools

| Tool | Used by |
|---|---|
| AWS CLI | AWS administration and evidence collection |
| Terraform | Infrastructure as Code projects |
| Docker | Local container, ECR, and recovery labs |
| Ansible | Server configuration lab |
| `kubectl` | Amazon EKS lab |
| Windows Server / hypervisor | Active Directory and DNS labs |

Confirm the AWS account and region before every deployment. AWS resources may incur charges.

## Quick start

1. Clone this repository:

   ```bash
   git clone <repository-url>
   cd final-capstone-solutions
   ```

2. Open the catalog below and select one lab.
3. Copy the complete numbered folder into a separate working directory.
4. Complete the lab and save evidence in the folder's `p*_output/` or `p*-output/` directory.
5. Destroy or remove all resources when finished.

There is no required lab order and no repository-level setup script. AWS Terraform labs maintain separate state per project. GitHub discovers workflows only when a project's `.github/` directory is placed at the Git repository root.

### Terraform quick reference

For projects that provide Terraform configuration:

```bash
cd <project-folder>
cp terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

# Follow the project's verification steps.

terraform destroy
```

Edit `terraform.tfvars` only for local configuration. Never commit credentials, state, saved plans, or private keys.

## Project catalog

| # | Project | Goal | Primary technologies |
|---:|---|---|---|
| 01 | [Linux EC2 web server](01-ec2-web/README.md) | Deploy an Apache or Nginx web server on AWS. | EC2, VPC, Terraform |
| 02 | [S3 static website](02-s3-site/README.md) | Publish a static website from Amazon S3. | S3, Terraform |
| 03 | [EC2 CPU alarm](03-cpu-alarm/README.md) | Alert when EC2 CPU utilization crosses a threshold. | CloudWatch, EC2, Terraform |
| 04 | [IAM user automation](04-iam-user/README.md) | Create a least-privilege read-only IAM user. | IAM, S3, Terraform |
| 05 | [Linux permissions](05-linux-permissions/README.md) | Restrict access with users, groups, and Unix permissions. | Linux, Bash |
| 06 | [Version-controlled infrastructure](06-git/README.md) | Track and review an infrastructure change with Git. | Git, GitHub |
| 07 | [Terraform CI checks](07-ci-checks/README.md) | Run formatting and validation checks in CI. | GitHub Actions, Terraform |
| 08 | [Local Docker application](08-docker/README.md) | Build and run an application in Docker. | Docker, nginx |
| 09 | [Windows domain controller](09-ad/README.md) | Configure Active Directory and domain users. | Windows Server, AD DS |
| 10 | [Internal DNS](10-dns/README.md) | Resolve an internal application by hostname. | Windows DNS |
| 11 | [Branch protection and review](11-branch-policy/README.md) | Require pull request reviews for infrastructure changes. | GitHub |
| 12 | [Terraform plan in CI](12-ci-plan/README.md) | Generate and preserve Terraform plans in CI. | GitHub Actions, Terraform |
| 13 | [Amazon ECR image](13-ecr/README.md) | Build, scan, and publish a container image. | Docker, Amazon ECR |
| 14 | [Amazon EKS application](14-eks/README.md) | Deploy a replicated application to Kubernetes. | EKS, Kubernetes, kubectl |
| 15 | [Ansible server configuration](15-ansible/README.md) | Configure and verify an Ubuntu server remotely. | Ansible, Linux, LXD |
| 16 | [ACM HTTPS](16-https/README.md) | Serve traffic over HTTPS with an ACM certificate. | ACM, Route 53, ALB, Terraform |
| 17 | [CloudWatch log forwarding](17-cloudwatch-logs/README.md) | Centralize EC2 system logs in CloudWatch Logs. | CloudWatch Agent, EC2 |
| 18 | [Infrastructure GitOps](18-gitops/README.md) | Deploy infrastructure through a reviewed workflow. | GitHub Actions, S3, Terraform |
| 19 | [Scheduled S3 backups](19-s3-backup/README.md) | Automate recurring private S3 backup uploads. | EC2, S3, cron, Terraform |
| 20 | [Application Load Balancer](20-load-balancer/README.md) | Distribute traffic across healthy web servers. | ALB, EC2, Terraform |
| 21 | [CloudWatch dashboard](21-dashboard/README.md) | Visualize EC2 CPU, network, and status metrics. | CloudWatch, EC2, Terraform |
| 22 | [S3 lifecycle policy](22-lifecycle/README.md) | Expire scoped log objects to control storage costs. | S3, Terraform |
| 23 | [IAM role-based access](23-instance-role/README.md) | Access S3 from EC2 through an instance role. | IAM, SSM, EC2, S3 |
| 24 | [Incident recovery drill](24-recovery/README.md) | Detect and recover from a simulated service failure. | Docker, Bash, incident response |

## Repository structure

```text
.
├── README.md                 # Repository overview
├── Questions.md              # Assessment questions
├── assets/                   # Submission templates
└── <number>-<name>/          # One standalone lab
    ├── README.md             # Lab summary
    ├── *.tf / *.yaml / ...   # Lab implementation
    └── p*_output/            # Screenshots or text evidence
```

Terraform projects usually include `versions.tf`, `providers.tf`, `variables.tf`, resource files, `terraform.tfvars.example`, and `outputs.tf`. Do not treat checked-in state or saved plans as portable deployment artifacts.

## Evidence and deliverables

Most labs require:

- A repository or pull request URL
- Screenshots or command output
- Terraform apply or validation output
- A completed incident report where applicable

Store evidence locally and redact account IDs, credentials, private host names, and other organization-specific details before sharing. Never include AWS credentials or private keys.

## Safety and cost control

- Use disposable accounts, repositories, virtual machines, and resource names.
- Set a budget and review estimated AWS costs before deployment.
- Use short-lived credentials and confirm the account and region.
- Never publish Terraform state, saved plans, `.terraform/`, `.tfvars`, credentials, or private keys.
- Use approved consoles or Session Manager for interactive access.
- Keep evidence limited to what the lab requires.

## Cleanup

Complete cleanup immediately after evidence collection:

- Run `terraform destroy` for Terraform labs and confirm the resources are gone.
- Delete CloudFormation stacks and local container resources where applicable.
- Remove temporary IAM users, keys, repositories, and uploaded test files.
- Retain only sanitized evidence for submission.

## 