# Commit Conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org/) for automated versioning and changelog generation via [semantic-release](https://semantic-release.gitbook.io/).

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Commit Types

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | A new feature | Minor |
| `fix` | A bug fix | Patch |
| `docs` | Documentation changes only | None |
| `style` | Code style changes (formatting, etc.) | None |
| `refactor` | Code changes that neither fix a bug nor add a feature | None |
| `test` | Adding or updating tests | None |
| `chore` | Changes to build process or auxiliary tools | None |
| `ci` | Changes to CI/CD configuration | None |
| `revert` | Reverting a previous commit | Patch |

## Breaking Changes

Append `!` after the type/scope or add `BREAKING CHANGE:` in the footer to trigger a major version bump:

```bash
feat!: remove deprecated tfsec tool

BREAKING CHANGE: tfsec has been removed. Use trivy config for Terraform scanning.
```

## Examples

```bash
# Feature
feat(docker): add support for arm64 architecture

# Bug fix
fix(build): resolve binary download for aarch64

# Documentation
docs: update README with new tool versions

# CI change
ci(actions): add multi-platform build workflow

# Chore
chore(deps): bump terraform version to 1.14.0
```

## Rules

- Use imperative mood ("add feature" not "added feature")
- Don't capitalize the first letter of the subject
- No period at the end of the subject
- Keep subject line under 72 characters
- Separate subject from body with a blank line

## How Semantic Release Uses Commits

When commits are merged to `main`:

1. `feat` commits trigger a **minor** version bump (e.g., 1.2.0 -> 1.3.0)
2. `fix` commits trigger a **patch** version bump (e.g., 1.2.0 -> 1.2.1)
3. `BREAKING CHANGE` triggers a **major** version bump (e.g., 1.2.0 -> 2.0.0)
4. Other types (`docs`, `chore`, `ci`, etc.) do **not** trigger a release

The changelog is generated automatically from commit messages.
