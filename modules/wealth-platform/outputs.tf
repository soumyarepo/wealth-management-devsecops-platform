output "client_documents_bucket" {
  value = aws_s3_bucket.client_documents.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.wealth_data_key.arn
}

output "readonly_policy_arn" {
  value = aws_iam_policy.readonly_policy.arn
}
