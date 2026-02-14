# Quick Start

Get up and running with the Terraform Toolkit Docker image in minutes.

## Prerequisites

Make sure you have [Docker](https://docs.docker.com/get-docker/) installed on your system.

## Pull the Image

```bash
docker pull ops4life/terraform-toolkit:latest
```

The image is available on [Docker Hub](https://hub.docker.com/r/ops4life/terraform-toolkit).

## Run the Container

Start an interactive session:

```bash
docker run -it ops4life/terraform-toolkit:latest
```

You now have access to all bundled tools:

```bash
terraform --version
terragrunt --version
checkov --version
terraform-docs --version
tflint --version
trivy --version
aws --version
eksctl version
pre-commit --version
```

## Run Terraform Commands

Mount your working directory and run Terraform:

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest terraform init
```

## Run Security Scans

Scan your Terraform configurations with Checkov:

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest checkov -d .
```

Scan with Trivy:

```bash
docker run -v $(pwd):/workspace -w /workspace ops4life/terraform-toolkit:latest trivy config .
```

## Next Steps

- Read the [Usage Guide](usage.md) for detailed instructions on CI integration and advanced usage
- Check the [Configuration Reference](../reference/configuration.md) for customizing tool versions
