# Terraform Web App Backend

A production-grade web application backend provisioned on AWS using Terraform. EC2 runs the web server inside a custom VPC, RDS PostgreSQL handles the database in private subnets, and S3 stores app files with encryption and versioning. Deployed across dev, staging, and production environments using a reusable module architecture.

---

## Architecture

```
Internet → EC2 (public subnet) → RDS PostgreSQL (private subnets)
                ↓
              S3 (encrypted app file storage)
```

- **VPC** isolates all resources in a private network with public and private subnets across two AZs
- **EC2** runs the web server (Amazon Linux 2) in the public subnet with HTTP/HTTPS/SSH access
- **RDS PostgreSQL 16** lives in private subnets, accessible only from the EC2 security group
- **S3** stores app files with AES-256 encryption, versioning, and no public access
- **IAM** gives EC2 an instance profile role to access S3 without hardcoded credentials

---

## Module Structure

```
web-app-backend/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   └── prod/
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
└── modules/
    ├── vpc/   # VPC, subnets, internet gateway, route tables
    ├── ec2/   # Amazon Linux 2 web server with security group
    ├── rds/   # PostgreSQL 16 in private subnets
    ├── s3/    # Encrypted, versioned app file bucket
    └── iam/   # EC2 instance profile with scoped S3 access
```

---

## Tech Stack

- **Terraform** >= 1.0
- **AWS Provider** ~> 5.0
- **Region:** `us-east-1`
- **Remote State:** S3 backend (`francisco-guardado-terraform-state`)

---

## Resources Managed

| Module | Resource | Description |
|---|---|---|
| `vpc` | `aws_vpc` | Custom VPC (`10.2.0.0/16`) with DNS enabled |
| `vpc` | `aws_internet_gateway` | Internet access for the public subnet |
| `vpc` | `aws_subnet` (x3) | 1 public + 2 private subnets across 2 AZs |
| `vpc` | `aws_route_table` | Routes public subnet traffic to internet |
| `ec2` | `aws_instance` | Amazon Linux 2 web server (`t2.micro`) |
| `ec2` | `aws_security_group` | HTTP (80), HTTPS (443), SSH (22) ingress |
| `ec2` | `data.aws_ami` | Auto-fetches latest Amazon Linux 2 AMI |
| `rds` | `aws_db_instance` | PostgreSQL 16 (`db.t3.micro`, 20GB) |
| `rds` | `aws_db_subnet_group` | Spans both private subnets |
| `rds` | `aws_security_group` | Only EC2 security group can connect on 5432 |
| `s3` | `aws_s3_bucket` | App files bucket |
| `s3` | `aws_s3_bucket_public_access_block` | Blocks all public access |
| `s3` | `aws_s3_bucket_server_side_encryption_configuration` | AES-256 encryption at rest |
| `s3` | `aws_s3_bucket_versioning` | Versioning enabled for file recovery |
| `iam` | `aws_iam_role` | EC2 instance role |
| `iam` | `aws_iam_instance_profile` | Attaches IAM role to EC2 |
| `iam` | `aws_iam_policy` | Scoped S3 read/write/delete/list policy |

---

## Usage

**Initialize (run from an environment directory):**
```bash
cd environments/prod
terraform init
```

**Preview changes:**
```bash
terraform plan
```

**Apply infrastructure:**
```bash
terraform apply
```

**Destroy infrastructure:**
```bash
terraform destroy
```

---

## Key Concepts Demonstrated

- Custom VPC with public/private subnet separation across multiple AZs
- RDS in private subnets, locked down to EC2 only via security group rules
- EC2 IAM instance profile -- no hardcoded AWS credentials on the server
- S3 with AES-256 encryption, full public access block, and versioning for recovery
- Dynamic AMI lookup via `data.aws_ami` -- no hardcoded AMI IDs
- Final RDS snapshot on destroy in prod (`skip_final_snapshot = false`)
- Remote S3 backend for shared state across environments

---

## Author

**Francisco Guardado**
