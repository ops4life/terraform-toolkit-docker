# Security

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly. **Do NOT publicly disclose security vulnerabilities.**

### How to Report

1. **GitHub Security Advisories** (Recommended)
    - Navigate to the "Security" tab of the repository
    - Click "Report a vulnerability"
    - Fill out the vulnerability report form

2. **Email** - Contact the maintainers with a detailed description and steps to reproduce

## Automated Security Scanning

This project implements multiple layers of security scanning:

### CI/CD Security Tools

| Tool | Purpose |
|------|---------|
| **Gitleaks** | Secret scanning in pre-commit hooks and CI/CD |
| **Dependabot** | Automated dependency vulnerability updates |
| **Dependency Review** | Supply chain security analysis on pull requests |
| **CodeQL** | Static code analysis for security vulnerabilities |
| **Trivy** | Container and filesystem vulnerability scanning |

### Container Security

The Docker image follows security best practices:

- **Non-root user**: Runs as `tf-user` (UID 1000) by default
- **Minimal packages**: Only essential runtime dependencies installed
- **No sudo**: The sudo package is not included in the image
- **Pinned versions**: All tool versions are explicitly pinned

## Security Update Process

1. **Vulnerability Assessment** - Reported vulnerabilities are assessed within 48 hours
2. **Fix Development** - Critical vulnerabilities are prioritized immediately
3. **Testing** - All security fixes are thoroughly tested
4. **Release** - Security updates are released as patch versions
5. **Disclosure** - Public disclosure occurs after the fix is released

## Security Best Practices for Users

When using this image:

1. **Keep updated** - Always use the latest image version
2. **Install pre-commit hooks** - Run `pre-commit install` immediately
3. **Enable branch protection** - Configure GitHub branch protection rules
4. **Rotate secrets** - Never commit secrets; rotate if accidentally exposed
5. **Use signed commits** - Enable GPG signing for commits

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest  | Yes       |
| Older   | No        |
