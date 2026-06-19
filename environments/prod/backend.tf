terraform {
  backend "s3" {
    bucket         = "wealth-management-terraform-state-demo"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "wealth-management-terraform-locks"
    encrypt        = true
  }
}
