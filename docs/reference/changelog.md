# Changelog

The changelog is automatically generated from [conventional commits](../guides/commit-conventions.md) using [semantic-release](https://semantic-release.gitbook.io/).

## Viewing the Changelog

The full changelog is maintained in the repository root:

- [CHANGELOG.md on GitHub](https://github.com/ops4life/terraform-toolkit-docker/blob/main/CHANGELOG.md)

## GitHub Releases

Each release includes enhanced release notes with:

- Tool version details
- Docker pull commands
- Links to the Docker Hub image

View all releases on the [GitHub Releases page](https://github.com/ops4life/terraform-toolkit-docker/releases).

## How Releases Work

1. Commits following [conventional commit format](../guides/commit-conventions.md) are merged to `main`
2. Semantic-release analyzes commit messages to determine the version bump
3. A new git tag and GitHub release are created automatically
4. The build workflow builds and pushes multi-arch Docker images
5. Release notes are enhanced with tool versions and Docker pull commands
