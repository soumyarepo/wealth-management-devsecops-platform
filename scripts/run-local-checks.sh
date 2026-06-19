#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-dev}
cd "environments/${ENVIRONMENT}"

terraform init
terraform fmt -check -recursive
terraform validate
tflint --init
tflint --recursive
checkov -d ../../ --soft-fail
terraform plan -var-file="${ENVIRONMENT}.tfvars.example"
