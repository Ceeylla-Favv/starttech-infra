# StartTech Infrastructure

Terraform-managed AWS infrastructure for the StartTech application.

---

## Architecture

```text
Internet → CloudFront → S3 (frontend)
Internet → ALB → EC2 Auto Scaling Group (backend API)
EC2 → ElastiCache Redis (caching/sessions)
EC2 → MongoDB Atlas (database)
EC2 → CloudWatch (logs and metrics)
```

---

## Infrastructure Components

| Component | Type | Purpose |
|---|---|---|
| VPC | Networking | Isolated network with public and private subnets |
| ALB | Load Balancer | Distributes traffic to backend EC2 instances |
| Auto Scaling Group | Compute | 1–4 EC2 t3.micro instances, scales on CPU |
| S3 Bucket | Storage | Hosts compiled React frontend files |
| CloudFront | CDN | Global content delivery for frontend |
| ElastiCache Redis | Cache | Session storage and API caching |
| CloudWatch | Monitoring | Centralised logs and metrics |

---

## Repository Structure

```text
starttech-infra/
├── .github/workflows/
│   └── infrastructure-deploy.yml   # Deploys Terraform on push to main
├── terraform/
│   ├── main.tf                     # Root module — all resources
│   ├── variables.tf                # Input variables
│   ├── outputs.tf                  # Output values
│   ├── terraform.tfvars.example    # Example values (copy to terraform.tfvars)
│   └── modules/
│       ├── networking/             # VPC, subnets, security groups
│       ├── compute/                # EC2, ALB, ASG, IAM roles
│       ├── storage/                # S3 bucket and website config
│       └── monitoring/             # CloudWatch log groups and alarms
├── scripts/
│   └── deploy-infrastructure.sh    # Manual deploy script
├── monitoring/
│   ├── cloudwatch-dashboard.json   # Dashboard definition
│   ├── alarm-definitions.json      # Alarm thresholds
│   └── log-insights-queries.txt    # Useful log queries
└── README.md
```

---

## Prerequisites

Before deploying the infrastructure, ensure the following tools are installed and configured:

- AWS CLI configured using:

```bash
aws configure
```

- Terraform version `>= 1.6.0`
- IAM user with the required AWS permissions

---

## First Time Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/starttech-infra.git
cd starttech-infra
```

---

### 2. Create Your Terraform Variables File

Copy the example file:

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Open and edit the file:

```bash
nano terraform/terraform.tfvars
```

Fill in all required values. Refer to the example file for descriptions of each variable.

---

### 3. Deploy the Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Terraform will display the resources to be created.

Type:

```text
yes
```

when prompted to confirm deployment.

---

### 4. Save Terraform Outputs

After deployment completes, Terraform will output important values such as:

- Load balancer DNS
- CloudFront distribution URL
- S3 bucket name
- Redis endpoint

These values should be stored securely and added as GitHub Secrets in the application repository.

---

## CI/CD Pipeline

Any push to the `main` branch affecting the `terraform/` directory automatically triggers deployment through GitHub Actions.

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `AWS_REGION` | AWS region (e.g. `eu-west-1`) |
| `S3_BUCKET_NAME` | Frontend S3 bucket name |
| `MONGO_URI` | MongoDB Atlas connection string |
| `ECR_REPOSITORY_URL` | ECR repository URI for backend image |

---

## Scaling Policy

The Auto Scaling Group automatically scales EC2 instances based on CPU utilisation.

### Scale Up

- Trigger: CPU usage greater than `75%`
- Duration: `4 minutes`
- Action: Add `1` EC2 instance

### Scale Down

- Trigger: CPU usage lower than `25%`
- Duration: `4 minutes`
- Action: Remove `1` EC2 instance

### Limits

| Setting | Value |
|---|---|
| Minimum Instances | 1 |
| Maximum Instances | 4 |

---

## Monitoring

Application logs and metrics are available in AWS CloudWatch.

### Log Group

```text
/starttech/backend
```

### View Logs

AWS Console → CloudWatch → Log Groups → `/starttech/backend`

Useful CloudWatch Insights queries can be found in:

```text
monitoring/log-insights-queries.txt
```

---

## Destroying Infrastructure

To remove all provisioned resources:

```bash
cd terraform
terraform destroy
```

Type:

```text
yes
```

when prompted.

> ⚠️ Warning: This permanently deletes all infrastructure resources managed by Terraform.