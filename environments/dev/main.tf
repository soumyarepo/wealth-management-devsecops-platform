module "wealth_platform" {
  source = "../../modules/wealth-platform"

  project_name        = var.project_name
  environment         = var.environment
  aws_region          = var.aws_region
  allowed_cidr_blocks = var.allowed_cidr_blocks
  cost_center         = var.cost_center
}
