# 🔐 Copilot Agent Allowlist Configuration

This document provides the list of external domains that must be allowlisted in GitHub Copilot Agent settings to enable automated workflows without firewall blocks.

## 🎯 Purpose

GitHub Copilot Agents run in a sandboxed environment with firewall restrictions. By default, most external network requests are blocked to ensure security. This allowlist enables the UBI repository's automation tools to function properly while maintaining security.

## 📋 Required Allowlist Entries

The following domains must be added to the **GitHub Copilot Agents Allowlist**:

### Core GitHub Services
- `api.github.com` - GitHub API for repository metadata, releases, and search
- `github.com` - GitHub web interface and repository access
- `raw.githubusercontent.com` - Raw file access from GitHub repositories
- `*.githubusercontent.com` - Wildcard for all GitHub user content domains

### Package Registries & Caches
- `ghcr.io` - GitHub Container Registry (for pulling/pushing images)
- `registry.npmjs.org` - npm package registry
- `pypi.org` - Python Package Index
- `files.pythonhosted.org` - Python package file hosting

### Development Tools & Testing
- `goss.rocks` - Goss testing framework installation
- `api.trivy.dev` - Trivy security scanner database
- `aquasecurity.github.io` - Trivy repository and updates

### Nix Ecosystem (Optional - for Nix-related features)
- `nixos.org` - Nix main website
- `releases.nixos.org` - Nix release downloads
- `cache.nixos.org` - Nix binary cache
- `channels.nixos.org` - Nix channels

### Devcontainer Features (Optional - for devcontainer introspection)
- `github.com/devcontainers/features` - Devcontainer Features repository

### Tool-Specific Domains
- `install.python-poetry.org` - Poetry installer
- `raw.githubusercontent.com/rhysd/actionlint` - actionlint installer
- `github.com/hadolint/hadolint` - Hadolint releases
- `github.com/mikefarah/yq` - yq releases
- `github.com/sigstore/cosign` - Cosign releases

## 🔧 How to Configure (Repository Admins Only)

### Step 1: Navigate to Repository Settings
1. Go to the UBI repository: `https://github.com/egohygiene/ubi`
2. Click **Settings** (requires admin access)
3. Navigate to **GitHub Copilot** → **Agents** → **Allowlist**

### Step 2: Add Allowlist Entries
Add each domain from the list above to the allowlist:

```
api.github.com
github.com
raw.githubusercontent.com
*.githubusercontent.com
ghcr.io
registry.npmjs.org
pypi.org
files.pythonhosted.org
goss.rocks
api.trivy.dev
aquasecurity.github.io
nixos.org
releases.nixos.org
cache.nixos.org
channels.nixos.org
install.python-poetry.org
```

### Step 3: Save Configuration
Click **Save** to apply the allowlist changes.

## ✅ Verification

After configuring the allowlist, verify it works by:

1. **Trigger a Copilot Agent workflow** (e.g., run `copilot-setup-steps.yml`)
2. **Check workflow logs** - Ensure no "Firewall rules blocked me from connecting" errors
3. **Test specific features**:
   - Nix installation checks should succeed
   - Devcontainer Feature lookups should work
   - Tool downloads should complete without errors

## 🚨 Security Considerations

### Why This is Safe
- **Official sources only**: All domains are official package registries, tool repositories, or GitHub services
- **Read-only access**: Copilot Agents only download public data; they cannot modify external systems
- **Scoped to repository**: Allowlist only applies to this repository, not organization-wide
- **Audit trail**: All network requests are logged in workflow runs

### What to Avoid
- ❌ Do NOT add unknown or untrusted domains
- ❌ Do NOT add overly broad wildcards (e.g., `*`)
- ❌ Do NOT add domains not required by documented workflows

## 🔄 Maintenance

### Adding New Tools
When adding new automation tools to UBI:

1. **Document the tool's domain** in this file
2. **Update the allowlist** in GitHub Settings
3. **Test the workflow** to verify network access
4. **Update `copilot-setup-steps.yml`** to pre-install the tool

### Removing Domains
If a tool is deprecated:

1. **Remove from `copilot-setup-steps.yml`**
2. **Update this documentation**
3. (Optional) Remove from allowlist to reduce attack surface

## 📚 Related Documentation

- [Copilot Environment Documentation](../docs/dev/copilot-environment.md)
- [Copilot Setup Workflow](workflows/copilot-setup-steps.yml)
- [GitHub Docs: Customize Agent Environment](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/customize-the-agent-environment)

## 🐛 Troubleshooting

### Issue: "Firewall rules blocked me from connecting to..."

**Solution**: Add the blocked domain to the allowlist following the steps above.

### Issue: Tool installation fails in Copilot Agent

**Possible causes**:
1. Domain not in allowlist → Add it
2. Tool URL changed → Update workflow with new URL
3. Network timeout → Retry the workflow

### Issue: Allowlist not taking effect

**Solution**:
1. Verify you have admin permissions
2. Ensure allowlist entries are exact (no typos)
3. Wait a few minutes for GitHub to propagate changes
4. Re-run the workflow

---

**Last Updated**: 2026-01-02  
**Maintained by**: UBI Repository Maintainers  
**Contact**: Open an issue at https://github.com/egohygiene/ubi/issues
