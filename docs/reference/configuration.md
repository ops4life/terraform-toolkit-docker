# Configuration

## Dockerfile Build Arguments

Tool versions are defined as `ARG` variables at the top of the Dockerfile. Override them at build time to customize the image.

### Builder Stage Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | [Terraform](https://www.terraform.io/) version | `1.14.4` |
| `TERRAGRUNT_VERSION` | [Terragrunt](https://terragrunt.gruntwork.io/) version | `0.99.1` |
| `TFDOCS_VERSION` | [terraform-docs](https://terraform-docs.io/) version | `0.21.0` |
| `TFLINT_VERSION` | [TFLint](https://github.com/terraform-linters/tflint) version | `0.61.0` |
| `TRIVY_VERSION` | [Trivy](https://trivy.dev/) version | `0.69.1` |
| `EKSCTL_VERSION` | [eksctl](https://eksctl.io/) version | `0.222.0` |

### Runtime Stage Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `CHECKOV_VERSION` | [Checkov](https://www.checkov.io/) version | `3.2.497` |
| `PRE_COMMIT_VERSION` | [pre-commit](https://pre-commit.com/) version | `4.5.1` |

### User Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `USERNAME` | Non-root user name | `tf-user` |
| `USER_UID` | User UID | `1000` |
| `USER_GID` | User GID | `1000` |

## Building with Custom Versions

Override a single tool version:

```bash
docker build --build-arg TERRAFORM_VERSION=1.14.0 -t terraform-toolkit:custom .
```

Override multiple versions:

```bash
docker build \
  --build-arg TERRAFORM_VERSION=1.14.0 \
  --build-arg TERRAGRUNT_VERSION=0.98.0 \
  --build-arg CHECKOV_VERSION=3.2.400 \
  -t terraform-toolkit:custom .
```

## Image Size Breakdown

The optimized image is approximately **1.61 GB** (27% smaller than the original 2.21 GB).

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

## Optimization Techniques

1. **Multi-stage build** - Alpine builder downloads binaries, Ubuntu runtime provides compatibility
2. **`--no-install-recommends`** - APT packages installed without recommended packages
3. **`--no-cache-dir`** - pip installations don't cache downloaded packages
4. **Python cleanup** - Removes `__pycache__`, `.pyc` files, and test directories
5. **No sudo** - The sudo package is not included (~40 MB saved)
6. **Combined RUN layers** - Fewer Docker layers reduce overhead

## Multi-Architecture Support

The image supports both `linux/amd64` and `linux/arm64` architectures. The build process automatically detects the target architecture and downloads the correct binaries.

```bash
# Build for specific platform
docker build --platform linux/amd64 -t terraform-toolkit:amd64 .
docker build --platform linux/arm64 -t terraform-toolkit:arm64 .
```
