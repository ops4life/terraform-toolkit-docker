# Usage Guide

Detailed instructions for using the Terraform Toolkit Docker image in various scenarios.

## Mounting Volumes

Mount your local Terraform project into the container:

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest terraform plan
```

### AWS Credentials

Pass AWS credentials to the container for cloud operations:

```bash
docker run -v $(pwd):/workspace -w /workspace \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION \
  ops4life/terraform-toolkit:latest terraform apply
```

Or mount your AWS credentials directory:

```bash
docker run -v $(pwd):/workspace -w /workspace \
  -v ~/.aws:/home/tf-user/.aws:ro \
  ops4life/terraform-toolkit:latest terraform apply
```

## CI/CD Integration

### GitHub Actions

Use the image in your GitHub Actions workflows:

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    container:
      image: ops4life/terraform-toolkit:latest
    steps:
      - uses: actions/checkout@v4
      - run: terraform init
      - run: terraform validate
      - run: terraform plan
```

### GitLab CI

```yaml
terraform:
  image: ops4life/terraform-toolkit:latest
  script:
    - terraform init
    - terraform validate
    - terraform plan
```

### Bitbucket Pipelines

```yaml
pipelines:
  default:
    - step:
        image: ops4life/terraform-toolkit:latest
        script:
          - terraform init
          - terraform validate
          - terraform plan
```

## Custom Tool Versions

Build the image with specific tool versions:

```bash
docker build --build-arg TERRAFORM_VERSION=1.14.0 -t terraform-toolkit:custom .
```

Available build arguments:

| Argument | Description |
|----------|-------------|
| `TERRAFORM_VERSION` | Terraform version |
| `TERRAGRUNT_VERSION` | Terragrunt version |
| `TFDOCS_VERSION` | terraform-docs version |
| `TFLINT_VERSION` | TFLint version |
| `TRIVY_VERSION` | Trivy version |
| `EKSCTL_VERSION` | eksctl version |
| `CHECKOV_VERSION` | Checkov version |
| `PRE_COMMIT_VERSION` | pre-commit version |

## Platform-Specific Builds

Build for a specific platform:

=== "AMD64"

    ```bash
    docker build --platform linux/amd64 -t terraform-toolkit:amd64 .
    ```

=== "ARM64"

    ```bash
    docker build --platform linux/arm64 -t terraform-toolkit:arm64 .
    ```

## Running Individual Tools

### Terraform

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  terraform init && terraform plan
```

### Checkov

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  checkov -d . --framework terraform
```

### TFLint

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  sh -c "tflint --init && tflint"
```

### Trivy (Terraform Scanning)

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  trivy config .
```

### terraform-docs

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  terraform-docs markdown table .
```

### Terragrunt

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest \
  terragrunt plan
```
