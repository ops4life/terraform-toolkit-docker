# Terraform Toolkit Docker Image

A comprehensive Docker image that bundles essential Terraform infrastructure tools into a single container for streamlined infrastructure management, security checks, and linting.

[![Docker Pulls](https://img.shields.io/docker/pulls/ops4life/terraform-toolkit)](https://hub.docker.com/r/ops4life/terraform-toolkit)
[![Docker Image Version](https://img.shields.io/docker/v/ops4life/terraform-toolkit?sort=semver)](https://hub.docker.com/r/ops4life/terraform-toolkit)
[![License](https://img.shields.io/github/license/ops4life/terraform-toolkit-docker)](https://github.com/ops4life/terraform-toolkit-docker/blob/main/LICENSE)

## Tools Included

| Tool | Description |
|------|-------------|
| [Terraform](https://www.terraform.io/) | Infrastructure as Code (IaC) tool to manage cloud and on-prem resources |
| [Terragrunt](https://terragrunt.gruntwork.io/) | A thin wrapper for Terraform that keeps configurations DRY |
| [Checkov](https://www.checkov.io/) | Static code analysis tool to detect cloud misconfigurations |
| [terraform-docs](https://terraform-docs.io/) | Generate documentation for Terraform modules |
| [TFLint](https://github.com/terraform-linters/tflint) | Linter for Terraform code to detect errors and enforce best practices |
| [Trivy](https://trivy.dev/) | Comprehensive security scanner for containers and Terraform configurations |
| [AWS CLI](https://aws.amazon.com/cli/) | AWS command line interface |
| [eksctl](https://eksctl.io/) | CLI for creating and managing EKS clusters |
| [pre-commit](https://pre-commit.com/) | Framework for managing pre-commit hooks |

## Features

- **Multi-architecture support** - Builds for both `linux/amd64` and `linux/arm64`
- **Non-root user** - Runs as `tf-user` (UID 1000) for security
- **Optimized image** - Multi-stage build with 27% size reduction (1.61 GB vs 2.21 GB)
- **Automated updates** - Weekly tool version checks with auto-merge PRs
- **Comprehensive CI/CD** - Build, test, security scan, and release automation

## Quick Links

<div class="grid cards" markdown>

- :material-rocket-launch: **[Quick Start](getting-started/quick-start.md)** - Get up and running in minutes
- :material-book-open-variant: **[Usage Guide](getting-started/usage.md)** - Detailed usage instructions
- :material-cog: **[Configuration](reference/configuration.md)** - Dockerfile ARGs and build options
- :material-handshake: **[Contributing](guides/contributing.md)** - How to contribute to the project

</div>
