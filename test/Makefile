# Makefile for testing terraform-toolkit Docker image

.PHONY: help test test-versions clean init validate plan apply destroy fmt lint security docs

# Docker image configuration
DOCKER_IMAGE ?= ops4life/terraform-toolkit:latest
WORK_DIR := /workspace

# Docker run command
DOCKER_RUN = docker run --rm -v $$(pwd):$(WORK_DIR) -w $(WORK_DIR) $(DOCKER_IMAGE)

help: ## Show this help message
	@echo "terraform-toolkit Docker Image Test Suite"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

test: ## Run full test suite
	@echo "Running full test suite..."
	@chmod +x test-toolkit.sh
	@./test-toolkit.sh

test-versions: ## Test all tool versions
	@echo "=== Tool Versions ==="
	@echo "Terraform:"
	@$(DOCKER_RUN) terraform version
	@echo ""
	@echo "Terragrunt:"
	@$(DOCKER_RUN) terragrunt --version
	@echo ""
	@echo "Checkov:"
	@$(DOCKER_RUN) checkov --version
	@echo ""
	@echo "TFLint:"
	@$(DOCKER_RUN) tflint --version
	@echo ""
	@echo "Trivy:"
	@$(DOCKER_RUN) trivy --version
	@echo ""
	@echo "terraform-docs:"
	@$(DOCKER_RUN) terraform-docs --version
	@echo ""
	@echo "eksctl:"
	@$(DOCKER_RUN) eksctl version
	@echo ""
	@echo "AWS CLI:"
	@$(DOCKER_RUN) aws --version
	@echo ""
	@echo "pre-commit:"
	@$(DOCKER_RUN) pre-commit --version

init: ## Initialize Terraform
	@echo "Initializing Terraform..."
	@$(DOCKER_RUN) terraform init

validate: init ## Validate Terraform configuration
	@echo "Validating Terraform configuration..."
	@$(DOCKER_RUN) terraform validate

fmt: ## Format Terraform files
	@echo "Formatting Terraform files..."
	@$(DOCKER_RUN) terraform fmt -recursive

fmt-check: ## Check Terraform formatting
	@echo "Checking Terraform formatting..."
	@$(DOCKER_RUN) terraform fmt -check -recursive

plan: validate ## Run Terraform plan
	@echo "Running Terraform plan..."
	@$(DOCKER_RUN) terraform plan -out=tfplan

apply: plan ## Apply Terraform changes
	@echo "Applying Terraform changes..."
	@$(DOCKER_RUN) terraform apply -auto-approve tfplan

destroy: ## Destroy Terraform resources
	@echo "Destroying Terraform resources..."
	@$(DOCKER_RUN) terraform destroy -auto-approve

output: ## Show Terraform outputs
	@echo "Terraform outputs:"
	@$(DOCKER_RUN) terraform output

lint: ## Run TFLint
	@echo "Initializing TFLint..."
	@$(DOCKER_RUN) tflint --init
	@echo "Running TFLint..."
	@$(DOCKER_RUN) tflint

security: ## Run security scans (Trivy and Checkov)
	@echo "Running Trivy config scan..."
	@$(DOCKER_RUN) trivy config . || true
	@echo ""
	@echo "Running Checkov..."
	@$(DOCKER_RUN) checkov -d . --compact || true

trivy: ## Run Trivy security scan
	@echo "Running Trivy filesystem scan..."
	@$(DOCKER_RUN) trivy fs . --security-checks vuln,config

docs: ## Generate documentation with terraform-docs
	@echo "Generating Terraform documentation..."
	@$(DOCKER_RUN) terraform-docs markdown table . > README.md
	@echo "Documentation generated in README.md"

terragrunt-init: ## Initialize Terragrunt
	@echo "Initializing Terragrunt..."
	@$(DOCKER_RUN) terragrunt init

terragrunt-plan: ## Run Terragrunt plan
	@echo "Running Terragrunt plan..."
	@$(DOCKER_RUN) terragrunt plan

terragrunt-apply: ## Apply Terragrunt changes
	@echo "Applying Terragrunt changes..."
	@$(DOCKER_RUN) terragrunt apply -auto-approve

clean: ## Clean up test files
	@echo "Cleaning up..."
	@rm -rf .terraform .terraform.lock.hcl terraform.tfstate* tfplan backend.tf output/
	@rm -f TERRAFORM_DOCS_OUTPUT.md
	@echo "Cleanup complete"

shell: ## Open interactive shell in Docker container
	@echo "Opening shell in terraform-toolkit container..."
	@docker run --rm -it -v $$(pwd):$(WORK_DIR) -w $(WORK_DIR) $(DOCKER_IMAGE) /bin/bash
