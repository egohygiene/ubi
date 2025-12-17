# Documentation Source of Truth Guidelines

This document defines the canonical locations for all documentation in the UBI repository to prevent drift and duplication.

---

## Canonical Documentation Locations

### Core Project Files

These files are the **single source of truth** and must never be duplicated:

| Document | Location | Purpose | Automated? |
|----------|----------|---------|------------|
| **CHANGELOG** | `/CHANGELOG.md` | Version history and release notes | ✅ Yes (bump-my-version) |
| **LICENSE** | `/LICENSE` | MIT License full text | ❌ No |
| **README** | `/README.md` | Project overview and quick start | ❌ No |
| **VERSION** | `/VERSION` | Current semantic version | ✅ Yes (bump-my-version) |
| **CONTRIBUTING** | `/CONTRIBUTING.md` | Contribution guidelines | ❌ No |
| **SECURITY** | `/SECURITY.md` | Security policy and reporting | ❌ No |

### Documentation Site Files

Documentation in the `docs/` directory may **reference** canonical files but should not duplicate their content:

| Document | Location | Type | References |
|----------|----------|------|------------|
| Changelog | `/docs/changelog.md` | Reference page | → `/CHANGELOG.md` |
| License | `/docs/license.md` | Reference page | → `/LICENSE` |
| Index | `/docs/index.md` | Landing page | Multiple |
| Architecture | `/docs/architecture.md` | Standalone | N/A |
| Troubleshooting | `/docs/troubleshooting.md` | Standalone | N/A |

---

## Why This Matters

### Problems with Duplication

1. **Content Drift**: Duplicated files inevitably diverge over time
2. **Confusion**: Contributors don't know which file to edit
3. **Maintenance Burden**: Multiple files need updates for single changes
4. **Automation Conflicts**: Automated tools (like bump-my-version) can't update duplicates
5. **Inconsistency**: Users see different information depending on where they look

### Our Solution

- **One canonical source** for each piece of information
- **Reference pages** that link to canonical sources (not copy content)
- **Clear documentation** about where each file lives
- **Automation-friendly** structure that tools can reliably update

---

## Guidelines for Contributors

### When Adding New Documentation

1. **Check if it exists**: Search for existing documentation on the topic
2. **Choose the right location**:
   - Root-level files (e.g., `README.md`) for essential project info
   - `docs/` directory for detailed guides and references
3. **Avoid duplication**: Link to existing content rather than copying
4. **Update navigation**: Add new docs to `mkdocs.yml` if needed

### When Updating Documentation

1. **Find the canonical source**: Check this guide for the authoritative location
2. **Edit only the canonical file**: Never edit reference/pointer pages
3. **Update references if needed**: If you change structure, update links
4. **Test your changes**: Build docs locally with `mkdocs serve`

### When Referencing Canonical Files

Use clear language to indicate you're referencing, not duplicating:

✅ **Good - Clear Reference**
```markdown
!!! info "Canonical Source"
    For the complete changelog, see [CHANGELOG.md](../CHANGELOG.md)
```

❌ **Bad - Copying Content**
```markdown
## Changelog

### Version 0.1.5
- Fixed version synchronization
...
```

---

## Automated Documentation

Some documentation is automatically generated or updated:

### bump-my-version

- **Updates**: `/CHANGELOG.md` and `/VERSION`
- **Configuration**: `pyproject.toml` ([tool.bumpversion] section)
- **Trigger**: Manual bump or GitHub Actions workflow
- **⚠️ Never manually edit**: These files during version bumps

### MkDocs Build

- **Generates**: Static site from `docs/` directory
- **Configuration**: `mkdocs.yml`
- **Output**: `site/` directory (not committed)
- **Deployment**: GitHub Actions to GitHub Pages

---

## File Organization Principles

### Root Directory

Files in the root directory should be:

- Essential project metadata (README, LICENSE, etc.)
- Version control files (.gitignore, .editorconfig)
- Build configuration (Dockerfile, pyproject.toml, etc.)
- CI/CD configuration (.github/)

**Keep it minimal** - move detailed docs to `docs/`

### Docs Directory

Files in `docs/` should be:

- Detailed guides and tutorials
- Architecture and design documentation
- Reference material
- Contributing and development guides

**Organize by topic** - use subdirectories for related content

---

## Checking for Duplicates

### Manual Check

Periodically search for potential duplicates:

```bash
# Find files with similar names
find . -name "*changelog*" -o -name "*license*" -o -name "*readme*"

# Search for duplicated content
grep -r "specific unique phrase" .
```

### Automated Audits

The repository includes audit scripts that check for:

- Duplicate file names
- Inconsistent version numbers
- Broken documentation links
- Missing source of truth references

See `audit/` directory for reports and scripts.

---

## Common Scenarios

### Scenario: I want to add a new feature to the changelog

**Answer**: You don't! The changelog is automatically updated by bump-my-version. Instead:

1. Make your changes
2. Create a PR with good description
3. Use bump-my-version to create a new version
4. The changelog is updated automatically

### Scenario: I want to update the license

**Answer**: Edit `/LICENSE` in the root directory. The docs reference page will automatically link to the updated version.

### Scenario: I want to add documentation about a new feature

**Answer**: 
1. Create a new file in `docs/` (e.g., `docs/new-feature.md`)
2. Add it to `mkdocs.yml` navigation
3. Link to it from relevant places (README, index.md, etc.)
4. Do NOT duplicate information already in other docs

### Scenario: I found duplicated content

**Answer**:
1. Identify the canonical source (use this guide)
2. Replace duplicates with references/links
3. Update any navigation or links
4. Submit a PR with the consolidation

---

## Version History

- **Initial version**: Created during documentation consolidation effort
- See [CHANGELOG.md](../CHANGELOG.md) for project version history

---

## Related Documentation

- [Contributing Guide](../CONTRIBUTING.md) - How to contribute to UBI
- [Release Process](../release-process.md) - How versions and releases work
- [Architecture](../architecture.md) - Overall project structure and design

---

**Remember**: When in doubt, link to the canonical source rather than copying content. This keeps our documentation maintainable and trustworthy.
