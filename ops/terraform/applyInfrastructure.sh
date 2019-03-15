#!/bin/bash -l
set -e

ENV=learning
echo "Running terraform for ${ENV}"

echo "...terraform init..."
terraform init -backend-config="${ENV}/backend.tfvars"

echo "...terraform apply..."
terraform apply -var-file="${ENV}/inputs.tfvars"
