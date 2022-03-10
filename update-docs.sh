#!/bin/bash

declare -a MODULE_FOLDERS=( "api_gateway" "iam/lambda" "iam/lambda_api_gateway" "iam/rds_proxy" "lambda" "rds" "secrets_manager" "security_group" "rds_proxy" "vpc")

if terraform-docs -h 2&> /dev/null; then
  echo "terraform-docs is installed - proceeding..."
else
  echo "aborting - terraform-docs is not installed"
  exit 1
fi

for i in "${MODULE_FOLDERS[@]}"
do
    terraform-docs markdown table --output-file README.md --output-mode inject "./${i}"
done
