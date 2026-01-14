# 🛠️ Terraform Toolkit Docker Image

[![CI](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/ci.yaml)
[![Build](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/build-tf-toolkit-image.yaml/badge.svg?branch=main)](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/build-tf-toolkit-image.yaml)
[![Test](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/test-image.yaml/badge.svg?branch=main)](https://github.com/ops4life/terraform-toolkit-docker/actions/workflows/test-image.yaml)
[![Docker Pulls](https://img.shields.io/docker/pulls/ops4life/terraform-toolkit)](https://hub.docker.com/r/ops4life/terraform-toolkit)
[![Docker Image Version](https://img.shields.io/docker/v/ops4life/terraform-toolkit?sort=semver)](https://hub.docker.com/r/ops4life/terraform-toolkit)
[![License](https://img.shields.io/github/license/ops4life/terraform-toolkit-docker)](LICENSE)

This repository provides a Docker image for a comprehensive Terraform toolkit. It bundles essential Terraform-related tools such as Terraform, Terragrunt, Checkov, TFDoc, TFLint, and Trivy to streamline infrastructure management, security checks, and linting.

## 🧰 Tools Included
The Docker image includes the following tools:

- 🌍 [Terraform](https://www.terraform.io/): Infrastructure as Code (IaC) tool to manage cloud and on-prem resources.
- 🚜 [Terragrunt](https://terragrunt.gruntwork.io/): A thin wrapper for Terraform that provides extra tools for keeping your configurations DRY.
- 🔍 [Checkov](https://www.checkov.io/): Static code analysis tool for infrastructure-as-code to detect cloud misconfigurations.
- 📄 [terraform-docs](https://terraform-docs.io/): Generate documentation for your Terraform modules in various output formats.
- 🔧 [TFLint](https://github.com/terraform-linters/tflint): A linter for Terraform code to detect potential errors and enforce best practices.
- 🛡️ [Trivy](https://trivy.dev/): Comprehensive security scanner for containers and Terraform configurations (replaces deprecated TFSec).

## 🚀 Getting Started

### ✅ Prerequisites
Make sure you have Docker installed on your system before using this image.

#### Install Docker
📥 Pulling the Docker Image

The image repository: [terraform-toolkit](https://hub.docker.com/r/ops4life/terraform-toolkit) 📦

To pull the pre-built Docker image from Docker Hub:

```bash
docker pull ops4life/terraform-toolkit:latest
```

#### 🏃 Usage
To run the container:

```bash
docker run -it ops4life/terraform-toolkit:latest
```

You can then use the following tools from within the container:

- terraform
- terragrunt
- checkov
- terraform-docs
- tflint
- trivy
- eksctl
- pre-commit

### 💡 Example
Run Terraform commands inside the container:

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest terraform init
```

This command mounts your current working directory (pwd) into the container’s /workspace directory and runs terraform init.

### ⚙️ Continuous Integration / Continuous Delivery
This repository includes several GitHub Actions workflows to automate testing, dependency updates, and release processes.

- 🔨 Build and Test: The build-tf-toolkit-image.yaml workflow builds and tests the Docker image automatically.
- 🧪 Image Testing: The test-image.yaml workflow runs comprehensive tests on all tools in the image.
- 🔄 Dependency Checks: The check-tool-updates.yaml and deps-review.yaml workflows handle automatic updates and reviews of dependencies.
- 📦 Release Automation: The release.yaml workflow automates creating new releases with semantic versioning.
- 🔍 Pre-commit Checks: The pre-commit-auto-update.yaml ensures that pre-commit hooks and lints are consistently maintained.

For detailed information about CI/CD workflows, see [.github/workflows/README.md](.github/workflows/README.md).

### 🧪 Testing

This repository includes a comprehensive test suite to validate all tools in the Docker image.

#### Quick Start

```bash
# Navigate to test directory
cd test

# Test all tool versions
make test-versions

# Run full test suite
make test

# Run Terraform workflow
make init validate plan

# Run security scans
make security
```

#### Test Coverage

- ✅ **Tool Versions** - Verify all 9 tools are installed and accessible
- ✅ **Terraform Workflow** - Test init, validate, fmt, plan, apply, destroy
- ✅ **Code Quality** - TFLint checks and formatting validation
- ✅ **Security Scanning** - Checkov and Trivy scans (Trivy replaces deprecated TFSec)
- ✅ **Documentation** - terraform-docs generation
- ✅ **Terragrunt** - Terragrunt workflow testing

For detailed testing instructions, see:
- [TEST_GUIDE.md](TEST_GUIDE.md) - Comprehensive testing guide
- [test/README.md](test/README.md) - Test suite documentation

### 🗂️ Project Structure
```bash
├── .editorconfig                 # Editor configuration for consistent coding styles
├── .github/                      # GitHub workflows for CI/CD automation
│   ├── ISSUE_TEMPLATE/           # Templates for GitHub issues
│   ├── workflows/                # CI/CD pipelines (build, test, release)
│   │   ├── build-tf-toolkit-image.yaml  # Multi-arch Docker build
│   │   ├── test-image.yaml       # Image testing workflow
│   │   ├── release.yaml          # Semantic release automation
│   │   └── README.md             # Workflow documentation
│   ├── dependabot.yml            # Automatic dependency updates
│   └── pull_request_template.md  # Template for pull requests
├── .gitignore                    # Files and directories to ignore in Git
├── .pre-commit-config.yaml       # Pre-commit hooks configuration
├── .vscode/extensions.json       # Recommended extensions for VSCode users
├── CODEOWNERS                    # File to manage repository code owners
├── Dockerfile                    # Dockerfile to build the image with the tools
├── LICENSE                       # License for the project
├── README.md                     # Documentation (you're reading this!)
├── TEST_GUIDE.md                 # Comprehensive testing guide
└── test/                         # Test suite for Docker image
    ├── main.tf                   # Sample Terraform configuration
    ├── variables.tf              # Variable definitions
    ├── terragrunt.hcl           # Terragrunt configuration
    ├── Makefile                  # Test automation commands
    ├── test-toolkit.sh          # Comprehensive test script
    └── README.md                 # Test documentation
```

### 🤝 Contributing
We welcome contributions! To get started:

- 🍴 Fork the repository.
- 🛠️ Create a new branch for your feature or bug fix.
- 📥 Submit a pull request when your changes are ready.
Please make sure to follow our coding style guidelines and ensure all tests pass.

### 📄 License
This project is licensed under the terms of the [MIT License](./LICENSE).
