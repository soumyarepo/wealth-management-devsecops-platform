variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name: dev, uat, or prod"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for private access examples"
  type        = list(string)
  default     = []
}

variable "cost_center" {
  description = "Cost center tag"
  type        = string
  default     = "WM-DEVSECOPS"
}
