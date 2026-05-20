#!/bin/bash
set -e
cd "$(dirname "$0")/../terraform"
echo "Init..."
terraform init
echo "Plan..."
terraform plan -out=tfplan
echo "Apply..."
terraform apply tfplan
echo "Outputs:"
terraform output