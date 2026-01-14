# Terraform Toolkit Docker Image - Testing Guide

This guide provides comprehensive instructions for testing the `terraform-toolkit` Docker image.

## Test Suite Overview

The test suite is located in the `test/` directory and includes:

### Test Files

```
test/
├── main.tf                    # Sample Terraform configuration
├── variables.tf               # Variable definitions
├── terragrunt.hcl            # Terragrunt configuration
├── .tflint.hcl               # TFLint configuration
├── .terraform-docs.yml       # terraform-docs configuration
├── test-toolkit.sh           # Comprehensive test script
├── Makefile                  # Make targets for testing
└── README.md                 # Detailed test documentation
```

## Quick Start

### Option 1: Using Make (Recommended)

```bash
cd test

# Show all available commands
make help

# Test all tool versions
make test-versions

# Run full Terraform workflow
make init validate plan

# Run security scans
make security

# Generate documentation
make docs

# Clean up
make clean
```

### Option 2: Using Test Script

```bash
cd test

# Run interactive test suite
chmod +x test-toolkit.sh
./test-toolkit.sh
```

## Test Categories

### 1. Version Verification

Verifies all tools are installed and accessible:

```bash
make test-versions
```

**Tools tested:**
- Terraform 1.13.5
- Terragrunt 0.93.5
- Checkov 3.2.492
- TFLint 0.59.1
- Trivy 0.67.2 (replaces deprecated TFSec)
- terraform-docs 0.20.0
- eksctl 0.216.0
- AWS CLI 2.x
- pre-commit 4.4.0

### 2. Terraform Workflow

Tests the complete Infrastructure as Code lifecycle:

```bash
# Initialize Terraform
make init

# Validate configuration
make validate

# Format code
make fmt

# Check formatting
make fmt-check

# Create execution plan
make plan

# Apply changes (interactive)
make apply

# Show outputs
make output

# Destroy resources (interactive)
make destroy
```

### 3. Code Quality & Linting

```bash
# Run TFLint
make lint

# Check code formatting
make fmt-check
```

### 4. Security Scanning

```bash
# Run Trivy and Checkov
make security

# Run Trivy filesystem scan
make trivy
```

### 5. Documentation Generation

```bash
# Generate terraform-docs
make docs
```

### 6. Terragrunt Testing

```bash
# Initialize Terragrunt
make terragrunt-init

# Plan with Terragrunt
make terragrunt-plan

# Apply with Terragrunt
make terragrunt-apply
```

## Testing Specific Image Versions

### Test Latest Version

```bash
export DOCKER_IMAGE=ops4life/terraform-toolkit:latest
make test-versions
```

### Test Specific Version

```bash
export DOCKER_IMAGE=ops4life/terraform-toolkit:1.63.4
make test-versions
```

### Test with Make Parameter

```bash
make test-versions DOCKER_IMAGE=ops4life/terraform-toolkit:1.63.4
```

## Interactive Shell Access

Open an interactive shell in the container:

```bash
make shell
```

Inside the container, run commands directly:

```bash
terraform version
terragrunt --version
checkov --version
tflint --version
trivy --version
terraform-docs --version
eksctl version
aws --version
pre-commit --version
```

## Example Test Workflow

### Complete Test Run

```bash
cd test

# 1. Verify all tools are available
make test-versions

# 2. Initialize and validate
make init validate

# 3. Check formatting
make fmt-check

# 4. Run linting
make lint

# 5. Run security scans
make security

# 6. Generate documentation
make docs

# 7. Create execution plan
make plan

# 8. Review plan and optionally apply
make apply

# 9. Check outputs
make output

# 10. Clean up
make destroy
make clean
```

## CI/CD Integration Examples

### GitHub Actions

```yaml
name: Test Terraform Toolkit Image

on:
  pull_request:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Test Tool Versions
        run: |
          cd test
          make test-versions

      - name: Test Terraform Workflow
        run: |
          cd test
          make init validate

      - name: Test Linting
        run: |
          cd test
          make lint

      - name: Test Security Scanning
        run: |
          cd test
          make security

      - name: Generate Documentation
        run: |
          cd test
          make docs
```

### GitLab CI

```yaml
test-toolkit:
  image: docker:latest
  services:
    - docker:dind
  script:
    - cd test
    - make test-versions
    - make init validate
    - make lint
    - make security
```

## Test Configuration Details

### Main Terraform Configuration

The test configuration (`test/main.tf`) creates:
- Random string resource (for testing)
- Random password resource (sensitive data testing)
- Local file resource (output testing)

**Features tested:**
- Resource creation
- Output values
- Sensitive data handling
- Provider usage

### TFLint Configuration

Rules enabled in `.tflint.hcl`:
- `terraform_naming_convention`
- `terraform_documented_variables`
- `terraform_documented_outputs`
- `terraform_unused_declarations`

### Security Scanning

**Trivy** checks:
- Terraform misconfigurations (replaces TFSec)
- Security best practices
- Vulnerabilities
- Configuration issues

**Checkov** checks:
- Infrastructure security
- Compliance standards
- Policy violations
- Secret scanning

## Troubleshooting

### Docker Permission Issues

```bash
# Linux: Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# macOS: Ensure Docker Desktop is running
```

### Image Not Found

```bash
# Pull the image
docker pull ops4life/terraform-toolkit:latest

# Verify image exists
docker images | grep terraform-toolkit
```

### Test Failures

```bash
# Run tests individually to isolate issues
make test-versions    # Check tool availability
make validate         # Check Terraform syntax
make lint            # Check linting issues
make security        # Check security issues
```

### Clean State

```bash
# Remove all test artifacts
make clean

# Start fresh
make init validate
```

## Advanced Usage

### Custom Terraform Configuration

Add your own Terraform code to test:

1. Create additional `.tf` files in `test/`
2. Run `make init validate`
3. Run `make plan` to see changes

### Testing with AWS/Cloud Resources

To test with actual cloud resources:

1. Mount AWS credentials:
```bash
docker run --rm \
  -v $(pwd):/workspace \
  -v ~/.aws:/root/.aws \
  -w /workspace \
  ops4life/terraform-toolkit:latest \
  terraform plan
```

2. Update `main.tf` with cloud resources
3. Run standard test workflow

### Custom Security Policies

Create custom Checkov policies:

```bash
# Create policies directory
mkdir -p test/policies

# Add custom policy files
# Run Checkov with custom policies
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ops4life/terraform-toolkit:latest \
  checkov -d . --external-checks-dir policies
```

## Continuous Testing

### Watch Mode for Development

```bash
# Run tests on file changes (requires entr)
ls *.tf | entr make validate lint
```

### Pre-commit Hooks

```bash
# Install pre-commit in the container
make shell

# Inside container
pre-commit install
pre-commit run --all-files
```

## Performance Testing

### Measure Execution Time

```bash
# Time Terraform operations
time make plan
time make apply
time make destroy

# Time security scans
time make security
time make trivy
```

## Test Reports

Generate test reports:

```bash
# TFLint with JSON output
docker run --rm -v $(pwd):/workspace -w /workspace \
  ops4life/terraform-toolkit:latest \
  tflint --format json > tflint-report.json

# Checkov with JSON output
docker run --rm -v $(pwd):/workspace -w /workspace \
  ops4life/terraform-toolkit:latest \
  checkov -d . -o json > checkov-report.json

# Trivy with JSON output
docker run --rm -v $(pwd):/workspace -w /workspace \
  ops4life/terraform-toolkit:latest \
  trivy fs . -f json > trivy-report.json
```

## Best Practices

1. **Always run `make test-versions` first** to verify tools are accessible
2. **Use `make clean` between test runs** to avoid state conflicts
3. **Review plans before applying** - Use `make plan` then manually apply
4. **Keep test configurations simple** - Focus on testing the tools, not complex infrastructure
5. **Run security scans regularly** - Integrate into CI/CD pipeline
6. **Document test failures** - Create issues with reproducible examples

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

## Support

For issues or questions:
1. Check the test README: `test/README.md`
2. Review this guide
3. Open an issue on GitHub with test output
