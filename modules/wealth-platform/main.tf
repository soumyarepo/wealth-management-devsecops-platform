locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
    Domain      = "WealthManagement"
  }
}

resource "aws_kms_key" "wealth_data_key" {
  description             = "KMS key for ${local.name_prefix} wealth management data encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-kms-key"
  })
}

resource "aws_kms_alias" "wealth_data_key_alias" {
  name          = "alias/${local.name_prefix}-data-key"
  target_key_id = aws_kms_key.wealth_data_key.key_id
}

resource "aws_s3_bucket" "client_documents" {
  bucket = "${local.name_prefix}-client-documents-${data.aws_caller_identity.current.account_id}"

  tags = merge(local.common_tags, {
    Name        = "${local.name_prefix}-client-documents"
    DataType    = "SensitiveClientDocuments"
    Application = "PortfolioManagement"
  })
}

resource "aws_s3_bucket_public_access_block" "client_documents" {
  bucket = aws_s3_bucket.client_documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "client_documents" {
  bucket = aws_s3_bucket.client_documents.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "client_documents" {
  bucket = aws_s3_bucket.client_documents.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.wealth_data_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "client_documents" {
  bucket = aws_s3_bucket.client_documents.id

  rule {
    id     = "archive-old-client-documents"
    status = "Enabled"

    filter {
      prefix = "archive/"
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_iam_policy" "readonly_policy" {
  name        = "${local.name_prefix}-readonly-client-documents-policy"
  description = "Least privilege read-only access for wealth management client documents"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.client_documents.arn,
          "${aws_s3_bucket.client_documents.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.wealth_data_key.arn
      }
    ]
  })

  tags = local.common_tags
}

data "aws_caller_identity" "current" {}
