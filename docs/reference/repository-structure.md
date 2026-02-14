# Repository Structure

Overview of the project's file and directory layout.

```
terraform-toolkit-docker/
├── .editorconfig                 # Editor configuration for consistent coding styles
├── .github/                      # GitHub configuration and workflows
│   ├── CONTRIBUTING.md           # Contributing guidelines
│   ├── ISSUE_TEMPLATE/           # Templates for GitHub issues
│   │   ├── bug_report.md
│   │   ├── documentation.md
│   │   ├── feature_request.md
│   │   └── issue_template.md
│   ├── SECURITY.md               # Security policy
│   ├── dependabot.yml            # Automatic dependency updates
│   ├── pull_request_template.md  # PR template
│   └── workflows/                # CI/CD pipelines
│       ├── build-tf-toolkit-image.yaml  # Multi-arch Docker build
│       ├── check-tool-updates.yaml      # Automated version updates
│       ├── ci.yaml                      # Unified CI workflow
│       ├── codeql.yaml                  # CodeQL security analysis
│       ├── deps-review.yaml             # Dependency review
│       ├── docs-deploy.yaml             # Documentation deployment
│       ├── gitleaks.yaml                # Secret detection
│       ├── release.yaml                 # Semantic release
│       ├── test-image.yaml              # Image testing
│       ├── trivy-scan.yaml              # Container scanning
│       └── README.md                    # Workflow documentation
├── .gitignore                    # Git ignore rules
├── .pre-commit-config.yaml       # Pre-commit hooks configuration
├── .releaserc.json               # Semantic release configuration
├── .templatesyncignore           # Template sync ignore rules
├── CHANGELOG.md                  # Auto-generated changelog
├── CODEOWNERS                    # Repository code owners
├── Dockerfile                    # Multi-stage Docker build
├── LICENSE                       # MIT License
├── README.md                     # Project README
├── TEST_GUIDE.md                 # Comprehensive testing guide
├── docs/                         # MkDocs documentation source
│   ├── index.md                  # Documentation home page
│   ├── getting-started/          # Getting started guides
│   ├── guides/                   # Contributor and workflow guides
│   ├── reference/                # Configuration and structure reference
│   └── stylesheets/              # Custom CSS
├── mkdocs.yml                    # MkDocs configuration
├── requirements.txt              # Python dependencies for MkDocs
└── test/                         # Test suite for Docker image
    ├── main.tf                   # Sample Terraform configuration
    ├── variables.tf              # Variable definitions
    ├── terragrunt.hcl            # Terragrunt configuration
    ├── Makefile                  # Test automation commands
    ├── test-toolkit.sh           # Comprehensive test script
    └── README.md                 # Test documentation
```

## Key Files

### Dockerfile

The core of the project. Uses a multi-stage build:

1. **Alpine builder stage** - Downloads all static binaries (Terraform, Terragrunt, TFLint, terraform-docs, Trivy, eksctl)
2. **Ubuntu runtime stage** - Installs AWS CLI, Python packages (Checkov, pre-commit), and copies binaries from the builder

Tool versions are defined as `ARG` variables at the top of the Dockerfile.

### mkdocs.yml

Configuration for the documentation site. Uses the Material theme with dark/light mode toggle, search, and code copy features.

### .releaserc.json

Configures [semantic-release](https://semantic-release.gitbook.io/) for automated versioning based on conventional commits.

### .pre-commit-config.yaml

Defines pre-commit hooks for code quality: trailing whitespace, end-of-file fixing, YAML validation, and MkDocs build verification.
