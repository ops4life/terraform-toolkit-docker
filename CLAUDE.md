# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository builds a Docker image (`ops4life/terraform-toolkit`) that bundles Terraform infrastructure tools into a single container. The image includes Terraform, Terragrunt, Checkov, TFLint, terraform-docs, Trivy, AWS CLI, eksctl, and pre-commit.

**Note**: TFSec has been removed as it's deprecated. Trivy now provides Terraform security scanning functionality (use `trivy config` for Terraform scanning).

## Architecture

### Core Components

**Dockerfile**: Single-stage build that installs all tools with pinned versions specified as ARG variables at the top of the file. The build process:
- Uses Ubuntu 22.04 as base image
- Supports multi-architecture builds (linux/amd64 and linux/arm64)
- Creates a non-root user (`tf-user`) for security
- Downloads and installs binaries from official release pages
- Verifies all installations at the end

**Version Management**: Tool versions are defined as ARG variables in the Dockerfile (lines 4-12). When updating versions, modify these ARG values at the top of the Dockerfile.

### CI/CD Automation

The repository uses GitHub Actions for automated workflows:

**build-tf-toolkit-image.yaml**: Multi-platform Docker image build
- Builds for both amd64 and arm64 architectures in parallel
- Uses Docker Buildx with digest-based approach for multi-arch manifests
- Pushes to Docker Hub (ops4life/terraform-toolkit)
- Triggered on: version tags (v*), main branch pushes, manual dispatch

**check-tool-updates.yaml**: Automated dependency updates
- Runs weekly (Monday 00:00 UTC) and on main branch pushes
- Fetches latest versions from GitHub releases for all tools
- Automatically creates PR with version updates and changelogs
- Auto-approves and auto-merges the PR using WORKFLOW_TOKEN
- Updates the Dockerfile ARG values using sed commands

**create-release.yaml**: Manual release workflow
- Creates git tags and GitHub releases
- Triggered via workflow_dispatch with version input

**Semantic Release**: Configured via `.releaserc.json`
- Uses conventional commits for versioning
- Generates CHANGELOG.md automatically
- Commits changelog with `[skip ci]` to prevent build loops

### Development Workflow

**Git Workflow**:
- **Never commit directly to the `main` branch**
- **Always create a feature branch** for changes
- Use descriptive branch names (e.g., `feat/add-new-tool`, `fix/update-versions`, `optimize-docker-image-size`)
- Create pull requests for all changes to be merged into `main`
- **NEVER automatically add AI attribution signatures** in commits like:
  - "🤖 Generated with [Claude Code]"
  - "Co-Authored-By: Claude <noreply@anthropic.com>"
  - Any AI tool attribution or signature

**Pre-commit Hooks**: Basic checks defined in `.pre-commit-config.yaml`
- trailing-whitespace
- end-of-file-fixer
- check-yaml

## Common Commands

### Building the Docker Image

```bash
# Build for local architecture
docker build -t terraform-toolkit .

# Build for specific platform
docker build --platform linux/amd64 -t terraform-toolkit .
docker build --platform linux/arm64 -t terraform-toolkit .

# Build with custom tool version
docker build --build-arg TERRAFORM_VERSION=1.14.0 -t terraform-toolkit .
```

### Testing the Image

```bash
# Run container interactively
docker run -it terraform-toolkit:latest

# Verify tool versions
docker run terraform-toolkit:latest terraform --version
docker run terraform-toolkit:latest terragrunt --version
docker run terraform-toolkit:latest checkov --version

# Mount workspace and run Terraform
docker run -v $(pwd):/workspace -w /workspace terraform-toolkit:latest terraform init
```

### Updating Tool Versions

1. Edit the ARG variables in Dockerfile (lines 4-12)
2. Tool versions can also be updated automatically via the check-tool-updates workflow
3. The workflow runs weekly and creates PRs with latest versions

### Running Pre-commit Hooks

```bash
# Install hooks
pre-commit install

# Run on all files
pre-commit run --all-files

# Run specific hook
pre-commit run trailing-whitespace --all-files
```

## Important Notes

- **Multi-arch builds**: The build workflow creates separate images for amd64 and arm64, then merges them into a single manifest
- **Registry**: Images are pushed to Docker Hub at `ops4life/terraform-toolkit`
- **Auto-merge**: Tool update PRs are automatically approved and merged using the WORKFLOW_TOKEN secret
- **Version tagging**: Docker images are tagged with git tags (semver pattern) and `latest`
- **Non-root user**: The container runs as `tf-user` (UID 1000) by default for security

## Image Size Optimizations

The Dockerfile uses a multi-stage build to minimize image size while maintaining full tool compatibility:

### Current Optimizations (Optimized: 1.61 GB, Original: 2.21 GB - 27% reduction)

1. **Multi-stage build**: Alpine builder stage downloads all binaries, Ubuntu runtime stage provides compatibility
2. **Alpine builder**: Uses Alpine 3.20 (7MB) for downloading binaries (wget, curl, unzip)
3. **Ubuntu runtime**: Uses Ubuntu 22.04 with --no-install-recommends for minimal dependencies
4. **Combined RUN layers**: Tool installations grouped into fewer RUN commands (10+ reduced to 6 layers)
5. **--no-install-recommends**: APT packages installed without recommended packages to save space
6. **--no-cache-dir**: Python pip installations don't cache downloaded packages (saves ~100MB+)
7. **Removed sudo**: The sudo package was removed as it's not needed (~40MB saved)
8. **Python cleanup**: Removes __pycache__, .pyc files, and test directories after pip install
9. **Minimal runtime deps**: Only git, python3, python3-pip, curl, unzip, bash in final image
10. **AWS CLI in runtime**: AWS CLI installed in Ubuntu stage for full compatibility

### Size Breakdown by Component

| Component | Size | Notes |
|-----------|------|-------|
| Checkov (Python) | ~236 MB | Infrastructure security scanning |
| AWS CLI | ~231 MB | AWS command line interface |
| Trivy | ~148 MB | Container and Terraform security scanner |
| eksctl | ~136 MB | Kubernetes cluster management |
| System packages | ~100 MB | Minimal: git, Python, bash, curl, unzip |
| Terraform | 87 MB | Core tool |
| Terragrunt | 67 MB | Terraform wrapper |
| TFLint | 47 MB | Terraform linter |
| terraform-docs | 16 MB | Documentation generator |

### Build Process

```bash
# Build optimized image with all tools
docker build -t terraform-toolkit:latest .

# The multi-stage build:
# 1. Alpine stage downloads all static binaries
# 2. Ubuntu stage installs AWS CLI and Python packages
# 3. Binaries copied from builder to runtime
# Result: Full functionality at 1.61 GB (27% smaller than 2.21 GB original)
```

## Security

- Uses Trivy for container vulnerability scanning (trivy-scan.yaml workflow)
- Uses Gitleaks for secret detection (gitleaks.yaml workflow)
- CodeQL analysis for code security (codeql.yaml workflow)
- Dependency review on pull requests (deps-review.yaml workflow)
