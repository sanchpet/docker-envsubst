# Agent Instructions

## Branch naming

Always work in a feature branch with a semantic name:

```bash
git checkout -b feature/<short-description>
```

Never commit directly to `main`.

## Commits

- Use conventional commit style: `feat:`, `fix:`, `chore:`, `docs:`
- Always add Claude as co-author:

```
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

## Git identity

This repo uses `sanchpet <petrov@sanch.pet>`. Verify before committing:

```bash
git config user.name   # sanchpet
git config user.email  # petrov@sanch.pet
```

## Build

```bash
docker build --build-arg GETTEXT_VERSION=0.25.1 -t envsubst .
```

## Test

```bash
echo 'Hello, $USER!' | docker run --rm -i -e USER=world envsubst
```

## Pre-commit

Installed via mise:

```bash
mise install
```

Run manually:

```bash
pre-commit run --all-files
```

## Versioning

The image version is driven by `ARG GETTEXT_VERSION` in `Dockerfile`. Renovate updates it automatically. To bump manually — change the ARG value and push to `main`.

## Pull requests

When a feature branch is ready, always:

1. Push the branch to origin
2. Open a PR against `main` with assignee `sanchpet`:

```bash
gh pr create --assignee sanchpet --base main --title "..." --body "..."
```

1. Return the PR URL to the user.
