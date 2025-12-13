# Troubleshooting Guide

This guide covers common issues you may encounter when working with UBI and their solutions.

---

## Table of Contents

- [Devcontainer Build Issues](#devcontainer-build-issues)
- [Docker Layer Caching](#docker-layer-caching)
- [Version Bump Issues](#version-bump-issues)
- [CHANGELOG Problems](#changelog-problems)
- [Environment Variable Issues](#environment-variable-issues)
- [Image Pull Failures](#image-pull-failures)
- [Permission Problems](#permission-problems)

---

## Devcontainer Build Issues

### Issue: Devcontainer fails to build with "base image not found"

**Symptoms:**
```
Error response from daemon: manifest for mcr.microsoft.com/devcontainers/base:2.1.2@sha256:... not found
```

**Causes:**
- Base image digest may have been updated or removed upstream
- Network connectivity issues to Microsoft Container Registry
- Docker daemon cache issues

**Solutions:**

1. **Verify base image availability:**
   ```bash
   docker pull mcr.microsoft.com/devcontainers/base:2.1.2
   ```

2. **Check the latest digest:**
   ```bash
   docker pull mcr.microsoft.com/devcontainers/base:2.1.2
   docker inspect mcr.microsoft.com/devcontainers/base:2.1.2 \
     --format='{{index .RepoDigests 0}}'
   ```

3. **Update Dockerfile if digest changed:**
   - Update `.devcontainer/Dockerfile` with new digest
   - See [README.md](../README.md#updating-the-base-image) for full instructions

4. **Clear Docker cache and rebuild:**
   ```bash
   docker system prune -f
   docker build -f .devcontainer/Dockerfile -t ubi:test . --no-cache
   ```

---

### Issue: "Permission denied" errors during devcontainer build

**Symptoms:**
```
mkdir: cannot create directory '/opt/universal/bin': Permission denied
```

**Causes:**
- Incorrect user context in Dockerfile
- Volume mount permission issues
- SELinux/AppArmor restrictions

**Solutions:**

1. **Check Dockerfile USER directive:**
   ```dockerfile
   # Should run as root during build, then switch to vscode
   USER root
   RUN mkdir -p /opt/universal/bin
   USER vscode
   ```

2. **For volume mount issues in docker-compose.yml:**
   ```yaml
   volumes:
     - ..:/workspace:cached  # Add :cached for better performance
   ```

3. **On SELinux systems, relabel volumes:**
   ```yaml
   volumes:
     - ..:/workspace:z  # :z for shared, :Z for private
   ```

---

### Issue: Devcontainer builds but environment is incorrect

**Symptoms:**
- Environment variables not set
- `/opt/universal` directories missing
- Wrong locale or timezone

**Solutions:**

1. **Verify environment in running container:**
   ```bash
   docker exec -it <container-name> env | grep UNIVERSAL
   docker exec -it <container-name> ls -la /opt/universal
   ```

2. **Force rebuild without cache:**
   ```bash
   # In VS Code: Cmd/Ctrl+Shift+P → "Dev Containers: Rebuild Container"
   # Or via CLI:
   docker-compose -f .devcontainer/docker-compose.yml build --no-cache
   ```

3. **Check for overridden environment variables:**
   - Review `.devcontainer/devcontainer.json` for conflicting `remoteEnv`
   - Check `.devcontainer/.env` file
   - Verify `docker-compose.yml` doesn't override ENVs

---

## Docker Layer Caching

### Issue: Builds are slow despite no changes

**Symptoms:**
- Every build re-downloads packages
- Dockerfile changes invalidate all subsequent layers
- CI builds take excessive time

**Solutions:**

1. **Optimize Dockerfile layer ordering:**
   - Put rarely-changing steps early (base image, system packages)
   - Put frequently-changing steps late (application code)
   - Group related RUN commands to reduce layers

2. **Use Docker BuildKit for better caching:**
   ```bash
   DOCKER_BUILDKIT=1 docker build -f .devcontainer/Dockerfile -t ubi:local .
   ```

3. **Enable BuildKit cache mounts:**
   ```dockerfile
   RUN --mount=type=cache,target=/var/cache/apt \
       apt-get update && apt-get install -y package-name
   ```

4. **In GitHub Actions, use caching:**
   ```yaml
   - name: Set up Docker Buildx
     uses: docker/setup-buildx-action@v3
     with:
       driver-opts: |
         network=host
         image=moby/buildkit:latest
   ```

---

### Issue: Cache not being used in CI

**Symptoms:**
- CI builds from scratch every time
- Previous layers not reused

**Solutions:**

1. **Verify GitHub Actions cache configuration:**
   ```yaml
   - name: Build and Push
     uses: docker/build-push-action@v5
     with:
       cache-from: type=gha
       cache-to: type=gha,mode=max
   ```

2. **Check layer order in Dockerfile:**
   - Ensure ARG declarations don't unnecessarily invalidate cache
   - Use multi-stage builds to cache intermediate stages

---

## Version Bump Issues

### Issue: `bump-my-version` command fails

**Symptoms:**
```
ERROR: Could not find a valid version string
ERROR: No files were modified
```

**Causes:**
- `pyproject.toml` configuration mismatch
- VERSION file doesn't match current version in config
- Regex pattern doesn't match version format

**Solutions:**

1. **Verify VERSION file content:**
   ```bash
   cat VERSION
   # Should contain only version number (e.g., 0.1.5) with newline
   ```

2. **Check pyproject.toml configuration:**
   ```bash
   grep -A 5 "\[tool.bumpversion\]" pyproject.toml
   # Verify current_version matches VERSION file
   ```

3. **Manually sync version numbers:**
   ```toml
   # In pyproject.toml
   [tool.poetry]
   version = "0.1.5"

   [tool.bumpversion]
   current_version = "0.1.5"
   ```

4. **Test version bump locally:**
   ```bash
   pip install bump-my-version
   bump-my-version patch --dry-run --verbose
   ```

---

### Issue: Version bump succeeds but tag not created

**Symptoms:**
- Commit created with new version
- Git tag not created
- CI publish workflow not triggered

**Causes:**
- `tag = false` in pyproject.toml (expected behavior)
- GitHub Actions workflow not pushing tags
- Permission issues in workflow

**Solutions:**

1. **Verify workflow configuration in `bump-version.yml`:**
   ```yaml
   - name: Push bump commit + tags
     uses: ad-m/github-push-action@master
     with:
       github_token: ${{ secrets.GITHUB_TOKEN }}
       branch: main
       tags: true  # Ensure this is set
   ```

2. **Check workflow permissions:**
   ```yaml
   permissions:
     contents: write  # Required for tag creation
   ```

3. **Manually create tag if needed:**
   ```bash
   git tag 0.1.6
   git push origin 0.1.6
   ```

---

## CHANGELOG Problems

### Issue: CHANGELOG.md not being updated

**Symptoms:**
- Version bumped but CHANGELOG unchanged
- CHANGELOG has duplicate entries
- Wrong format after bump

**Causes:**
- `pyproject.toml` CHANGELOG configuration incorrect
- Regex pattern not matching CHANGELOG format
- Manual edits broke the pattern matching

**Solutions:**

1. **Verify CHANGELOG configuration in pyproject.toml:**
   ```toml
   [[tool.bumpversion.files]]
   filename = "CHANGELOG.md"
   regex = true
   search = "\\A## "
   replace = """## {new_version} ({now:%Y-%m-%d})
   [Compare the full difference.](https://github.com/egohygiene/ubi/compare/{current_version}...{new_version})

   ## """
   ```

2. **Check CHANGELOG.md format:**
   - First line after any markdown comments should be `## X.Y.Z (YYYY-MM-DD)`
   - Pattern must match exactly

3. **Fix broken CHANGELOG:**
   ```bash
   # Ensure first version header starts at beginning of line
   # Example correct format:
   ## 0.1.5 (2025-12-11)
   [Compare the full difference.](https://github.com/egohygiene/ubi/compare/0.1.4...0.1.5)
   ```

4. **Test CHANGELOG update:**
   ```bash
   bump-my-version patch --dry-run --verbose
   # Check output for CHANGELOG modifications
   ```

---

### Issue: CHANGELOG has merge conflicts

**Symptoms:**
- Git merge conflicts in CHANGELOG.md
- Multiple version entries colliding

**Solutions:**

1. **Resolve manually prioritizing chronological order:**
   ```markdown
   ## 0.1.6 (2025-12-13)
   [Compare...]
   
   ## 0.1.5 (2025-12-11)
   [Compare...]
   ```

2. **Keep newest version at top:**
   - Remove conflict markers
   - Ensure versions are in descending order
   - Preserve all unique entries

---

## Environment Variable Issues

### Issue: XDG directories not being used by applications

**Symptoms:**
- Applications still write to `~/.config`
- Cache files in home directory
- XDG_* variables set but ignored

**Causes:**
- Application doesn't support XDG
- Variables set but directories don't exist
- Permission issues on XDG directories

**Solutions:**

1. **Verify directories exist and are writable:**
   ```bash
   ls -la /opt/universal/
   touch /opt/universal/config/test && rm /opt/universal/config/test
   ```

2. **Check if application supports XDG:**
   ```bash
   # Some apps need explicit configuration
   # Example for pip:
   mkdir -p $XDG_CONFIG_HOME/pip
   echo "[global]" > $XDG_CONFIG_HOME/pip/pip.conf
   ```

3. **Set application-specific overrides:**
   ```bash
   # Example for npm
   export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
   ```

---

## Image Pull Failures

### Issue: Cannot pull UBI image from GHCR

**Symptoms:**
```
Error response from daemon: unauthorized: authentication required
Error: ghcr.io/egohygiene/ubi:0.1.5 not found
```

**Solutions:**

1. **Authenticate to GitHub Container Registry:**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
   ```

2. **Verify image exists:**
   ```bash
   curl -s "https://ghcr.io/v2/egohygiene/ubi/tags/list" | jq
   ```

3. **Try with explicit tag:**
   ```bash
   docker pull ghcr.io/egohygiene/ubi:latest
   docker pull ghcr.io/egohygiene/ubi:0.1.5
   ```

4. **Check package visibility:**
   - Visit https://github.com/orgs/egohygiene/packages
   - Ensure package is public or you have access

---

## Permission Problems

### Issue: Cannot write to /opt/universal directories

**Symptoms:**
```
touch: cannot touch '/opt/universal/cache/test': Permission denied
```

**Solutions:**

1. **Check directory ownership:**
   ```bash
   ls -la /opt/universal/
   # Should be owned by vscode:vscode
   ```

2. **Fix permissions:**
   ```dockerfile
   # In Dockerfile:
   RUN chown -R vscode:vscode /opt/universal
   ```

3. **Verify current user:**
   ```bash
   whoami  # Should be 'vscode'
   id      # Check groups
   ```

---

## Getting Help

If you encounter issues not covered here:

1. **Check existing GitHub issues:**
   - [Open Issues](https://github.com/egohygiene/ubi/issues)
   - Search for similar problems

2. **Review logs:**
   - Docker build logs: `docker build ... 2>&1 | tee build.log`
   - Container logs: `docker logs <container-name>`
   - GitHub Actions logs: Check workflow run details

3. **Open a new issue:**
   - Use the issue template
   - Include reproduction steps
   - Attach relevant logs
   - Specify UBI version

4. **Useful debugging commands:**
   ```bash
   # Check container details
   docker inspect <container-name>
   
   # Shell into running container
   docker exec -it <container-name> bash
   
   # Check environment
   docker exec <container-name> env | sort
   
   # Verify filesystem
   docker exec <container-name> ls -laR /opt/universal
   ```

---

## Additional Resources

- [UBI Architecture Documentation](./architecture.md)
- [Release Process Guide](./release-process.md)
- [Security Overview](./security-overview.md)
- [Main README](../README.md)
- [GitHub Discussions](https://github.com/egohygiene/ubi/discussions)
