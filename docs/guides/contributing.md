# Contributing

Thank you for your interest in contributing to this project! This guide covers everything you need to get started.

## Getting Started

1. **Fork the repository** - Click the "Fork" button on the repository page
2. **Clone your fork**

    ```bash
    git clone https://github.com/YOUR-USERNAME/terraform-toolkit-docker.git
    cd terraform-toolkit-docker
    ```

3. **Add upstream remote**

    ```bash
    git remote add upstream https://github.com/ops4life/terraform-toolkit-docker.git
    ```

## Development Setup

1. **Install pre-commit hooks** (required)

    ```bash
    pre-commit install
    ```

2. **Verify installation**

    ```bash
    pre-commit run --all-files
    ```

3. **Create a feature branch**

    ```bash
    git checkout -b feat/your-feature-name
    ```

!!! warning "Never commit directly to main"
    Always create a feature branch for your changes and submit a pull request.

## Contribution Workflow

1. **Keep your fork updated**

    ```bash
    git fetch upstream
    git checkout main
    git merge upstream/main
    ```

2. **Make your changes** - Follow existing code patterns and add tests if applicable
3. **Test your changes**

    ```bash
    # Run pre-commit hooks
    pre-commit run --all-files

    # Build and test the Docker image
    docker build -t terraform-toolkit:test .
    cd test && make test-versions
    ```

4. **Commit your changes** - Follow [commit conventions](commit-conventions.md)
5. **Push and create a PR**

    ```bash
    git push origin feat/your-feature-name
    ```

## Pull Request Process

1. Ensure all CI checks pass
2. Fill out the pull request template
3. Link related issues using keywords (`fixes #123`, `closes #456`)
4. Wait for maintainer review

## Code Style

- **Indentation**: 2 spaces (enforced by EditorConfig)
- **Line Endings**: LF (Unix-style)
- **Charset**: UTF-8
- **Trailing Whitespace**: Removed automatically by pre-commit
- **Final Newline**: Required

## Code of Conduct

- Be respectful and professional
- Welcome newcomers and help them learn
- Accept constructive criticism gracefully
- Focus on what's best for the community

## Need Help?

- **Questions**: Open a [Discussion](https://github.com/ops4life/terraform-toolkit-docker/discussions)
- **Bug Reports**: Open an [Issue](https://github.com/ops4life/terraform-toolkit-docker/issues/new?template=bug_report.md)
- **Feature Requests**: Open an [Issue](https://github.com/ops4life/terraform-toolkit-docker/issues/new?template=feature_request.md)
