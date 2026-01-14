#!/bin/bash
set -e

# Test script for terraform-toolkit Docker image
# This script tests all tools included in the image

DOCKER_IMAGE="${DOCKER_IMAGE:-ops4life/terraform-toolkit:latest}"
WORK_DIR="/workspace"

echo "========================================"
echo "Testing terraform-toolkit Docker image"
echo "Image: ${DOCKER_IMAGE}"
echo "========================================"
echo ""

# Helper function to run commands in Docker
run_in_docker() {
  docker run --rm \
    -v "$(pwd):${WORK_DIR}" \
    -w "${WORK_DIR}" \
    "${DOCKER_IMAGE}" \
    "$@"
}

# Test 1: Verify tool versions
echo "=== Test 1: Verifying tool versions ==="
echo ""

echo "Terraform version:"
run_in_docker terraform version
echo ""

echo "Terragrunt version:"
run_in_docker terragrunt --version
echo ""

echo "Checkov version:"
run_in_docker checkov --version
echo ""

echo "TFLint version:"
run_in_docker tflint --version
echo ""

echo "Trivy version:"
run_in_docker trivy --version
echo ""

echo "terraform-docs version:"
run_in_docker terraform-docs --version
echo ""

echo "eksctl version:"
run_in_docker eksctl version
echo ""

echo "AWS CLI version:"
run_in_docker aws --version
echo ""

echo "pre-commit version:"
run_in_docker pre-commit --version
echo ""

# Test 2: Terraform init and validate
echo "=== Test 2: Terraform init and validate ==="
echo ""

echo "Running terraform init..."
run_in_docker terraform init
echo "✓ Terraform init successful"
echo ""

echo "Running terraform validate..."
run_in_docker terraform validate
echo "✓ Terraform validate successful"
echo ""

# Test 3: Terraform fmt
echo "=== Test 3: Terraform format check ==="
echo ""

echo "Running terraform fmt -check..."
if run_in_docker terraform fmt -check -recursive; then
  echo "✓ Terraform format check passed"
else
  echo "⚠ Terraform format check found issues (running fmt to fix)..."
  run_in_docker terraform fmt -recursive
  echo "✓ Files formatted"
fi
echo ""

# Test 4: TFLint
echo "=== Test 4: TFLint ==="
echo ""

echo "Initializing TFLint..."
run_in_docker tflint --init
echo ""

echo "Running TFLint..."
if run_in_docker tflint; then
  echo "✓ TFLint passed"
else
  echo "⚠ TFLint found issues"
fi
echo ""

# Test 5: Checkov
echo "=== Test 5: Checkov security scan ==="
echo ""

echo "Running Checkov..."
if run_in_docker checkov -d . --quiet --compact; then
  echo "✓ Checkov passed"
else
  echo "⚠ Checkov found issues"
fi
echo ""

# Test 6: terraform-docs
echo "=== Test 6: terraform-docs ==="
echo ""

echo "Generating documentation..."
run_in_docker terraform-docs markdown table . > TERRAFORM_DOCS_OUTPUT.md
if [ -s TERRAFORM_DOCS_OUTPUT.md ]; then
  echo "✓ terraform-docs generated documentation"
  echo ""
  echo "Documentation preview:"
  head -20 TERRAFORM_DOCS_OUTPUT.md
else
  echo "✗ terraform-docs failed to generate documentation"
fi
echo ""

# Test 7: Terraform plan
echo "=== Test 7: Terraform plan ==="
echo ""

echo "Running terraform plan..."
if run_in_docker terraform plan -out=tfplan; then
  echo "✓ Terraform plan successful"
else
  echo "✗ Terraform plan failed"
  exit 1
fi
echo ""

# Test 8: Terraform apply (auto-approve for testing)
echo "=== Test 8: Terraform apply ==="
echo ""

read -p "Do you want to run terraform apply? (yes/no): " -r
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
  echo "Running terraform apply..."
  if run_in_docker terraform apply -auto-approve tfplan; then
    echo "✓ Terraform apply successful"
  else
    echo "✗ Terraform apply failed"
    exit 1
  fi
  echo ""

  # Test 9: Terraform output
  echo "=== Test 9: Terraform output ==="
  echo ""

  echo "Terraform outputs:"
  run_in_docker terraform output
  echo ""

  # Test 10: Terraform destroy
  echo "=== Test 10: Terraform destroy ==="
  echo ""

  read -p "Do you want to run terraform destroy? (yes/no): " -r
  if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "Running terraform destroy..."
    if run_in_docker terraform destroy -auto-approve; then
      echo "✓ Terraform destroy successful"
    else
      echo "✗ Terraform destroy failed"
      exit 1
    fi
  fi
else
  echo "Skipping terraform apply"
fi
echo ""

# Test 11: Terragrunt (optional)
echo "=== Test 11: Terragrunt ==="
echo ""

read -p "Do you want to test Terragrunt? (yes/no): " -r
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
  echo "Running terragrunt plan..."
  if run_in_docker terragrunt plan; then
    echo "✓ Terragrunt plan successful"
  else
    echo "⚠ Terragrunt plan had issues"
  fi
else
  echo "Skipping Terragrunt test"
fi
echo ""

# Cleanup
echo "=== Cleanup ==="
echo ""

echo "Cleaning up test files..."
rm -f tfplan
rm -f TERRAFORM_DOCS_OUTPUT.md
echo "✓ Cleanup complete"
echo ""

echo "========================================"
echo "All tests completed!"
echo "========================================"
