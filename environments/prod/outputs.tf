output "client_documents_bucket" {
  value = module.wealth_platform.client_documents_bucket
}

output "kms_key_arn" {
  value = module.wealth_platform.kms_key_arn
}

output "readonly_policy_arn" {
  value = module.wealth_platform.readonly_policy_arn
}
