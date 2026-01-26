# Build stage - download and prepare binaries
FROM alpine:3.20 AS builder

# Set ARGs for tool versions
ARG TERRAFORM_VERSION=1.14.3
ARG TERRAGRUNT_VERSION=0.98.0
ARG TFDOCS_VERSION=0.21.0
ARG TFLINT_VERSION=0.60.0
ARG TRIVY_VERSION=0.68.2
ARG EKSCTL_VERSION=0.221.0

# Install build dependencies
RUN apk add --no-cache wget curl tar gzip unzip

# Create directory for binaries
RUN mkdir -p /tmp/bin

# Set ARCH for downloads
RUN case $(uname -m) in \
      x86_64) echo "amd64" > /tmp/arch ;; \
      aarch64) echo "arm64" > /tmp/arch ;; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac

# Download Terraform
RUN ARCH=$(cat /tmp/arch) && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    unzip -q terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip -d /tmp/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip

# Download Terragrunt
RUN ARCH=$(cat /tmp/arch) && \
    wget -q https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${ARCH} -O /tmp/bin/terragrunt && \
    chmod +x /tmp/bin/terragrunt

# Download Terraform Docs
RUN ARCH=$(cat /tmp/arch) && \
    wget -q https://github.com/terraform-docs/terraform-docs/releases/download/v${TFDOCS_VERSION}/terraform-docs-v${TFDOCS_VERSION}-linux-${ARCH}.tar.gz && \
    tar -xzf terraform-docs-v${TFDOCS_VERSION}-linux-${ARCH}.tar.gz -C /tmp/bin terraform-docs && \
    rm terraform-docs-v${TFDOCS_VERSION}-linux-${ARCH}.tar.gz

# Download TFLint
RUN ARCH=$(cat /tmp/arch) && \
    wget -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${ARCH}.zip && \
    unzip -q tflint_linux_${ARCH}.zip -d /tmp/bin/ && \
    rm tflint_linux_${ARCH}.zip

# Download Trivy
RUN case $(uname -m) in \
      x86_64) ARCH=64bit ;; \
      aarch64) ARCH=ARM64 ;; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${ARCH}.tar.gz && \
    tar -xzf trivy_${TRIVY_VERSION}_Linux-${ARCH}.tar.gz -C /tmp/bin trivy && \
    rm trivy_${TRIVY_VERSION}_Linux-${ARCH}.tar.gz

# Download eksctl
RUN ARCH=$(cat /tmp/arch) && \
    PLATFORM=Linux_${ARCH} && \
    wget -q https://github.com/eksctl-io/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_${PLATFORM}.tar.gz && \
    tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp/bin && \
    rm eksctl_${PLATFORM}.tar.gz

# Final stage - Ubuntu runtime image for full compatibility
FROM ubuntu:22.04

# Version args for Python packages
ARG CHECKOV_VERSION=3.2.497
ARG PRE_COMMIT_VERSION=4.5.1

# Add a non-root user
ARG USERNAME=tf-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install runtime dependencies only
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    ca-certificates \
    bash \
    curl \
    unzip && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Copy binaries from builder stage
COPY --from=builder /tmp/bin/* /usr/local/bin/

# Install AWS CLI v2 in final stage with download cache
RUN --mount=type=cache,target=/tmp/awscli-cache,sharing=locked \
    case $(uname -m) in \
      x86_64) ARCH=x86_64 ;; \
      aarch64) ARCH=aarch64 ;; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    CACHE_FILE="/tmp/awscli-cache/awscliv2-${ARCH}.zip" && \
    if [ ! -f "${CACHE_FILE}" ]; then \
      curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "${CACHE_FILE}"; \
    fi && \
    cp "${CACHE_FILE}" awscliv2.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Python packages with cache mount for faster builds
RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    pip3 install --prefer-binary \
    checkov==${CHECKOV_VERSION} \
    pre-commit==${PRE_COMMIT_VERSION} && \
    # Remove Python cache and test files
    find /usr/lib/python* -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/lib/python* -name '*.pyc' -delete 2>/dev/null || true && \
    find /usr/lib/python* -name 'tests' -type d -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/lib/python* -name 'test' -type d -exec rm -rf {} + 2>/dev/null || true

# Switch to non-root user
USER $USERNAME

# Verify installations
RUN terraform --version && \
    terragrunt --version && \
    checkov --version && \
    terraform-docs --version && \
    tflint --version && \
    trivy --version && \
    pre-commit --version && \
    aws --version && \
    eksctl version

# Set default user working directory
WORKDIR /home/$USERNAME
