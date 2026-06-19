# Wealth Management Terraform DevSecOps Project

This project demonstrates a secure Terraform module structure for a Wealth Management platform using separate Dev, UAT, and Prod environments.

## What this project includes

- Reusable Terraform modules
- Dev, UAT, Prod environment separation
- Remote Terraform backend using S3 and DynamoDB locking
- Backend encryption enabled
- Backend bucket versioning
- Restricted public access on S3 buckets
- GitHub Actions pipeline
- TFLint for Terraform quality checks
- Checkov for security scanning
- Placeholder for hardcoded secret scanning
- Manual approval gate for production apply

## Folder Structure

```text
wealth-management-terraform-devsecops/
├── .github/workflows/terraform-pipeline.yml
├── modules/
│   ├── secure-s3-backend/
│   └── wealth-platform/
├── environments/
│   ├── dev/
│   ├── uat/
│   └── prod/
├── scripts/
└── README.md
```

## Important Setup Step

Before running the main environment pipeline, create the Terraform backend once:

```bash
cd modules/secure-s3-backend
terraform init
terraform apply
```

This creates:

- S3 bucket for Terraform state
- DynamoDB table for state locking
- Encryption enabled
- Versioning enabled
- Public access blocked

## Pipeline Flow

```text
1. Checkout code
2. Configure AWS credentials
3. Install Terraform
4. Run TFLint
5. Run Checkov
6. Placeholder secret scanning
7. Terraform init with S3 backend and DynamoDB locking
8. Terraform fmt
9. Terraform validate
10. Terraform plan
11. Upload Terraform plan
12. Manual approval for production
13. Terraform apply
```

## Interview Explanation

In this project, we follow secure Terraform practices. Terraform state is stored in S3 with encryption, versioning, DynamoDB locking, and restricted access. We separate Dev, UAT, and Prod environments with different state files. Before applying infrastructure changes, the pipeline runs TFLint for Terraform best practices and Checkov for security checks. Production apply is protected using a manual approval gate.
