# MkDocs Setup and Configuration

This document provides instructions for maintaining and configuring the MkDocs documentation site for UBI.

---

## Overview

The UBI documentation site is built using:

- **MkDocs** - Static site generator for project documentation
- **Material for MkDocs** - Modern, feature-rich theme
- **GitHub Pages** - Hosting platform for the documentation site
- **GitHub Actions** - Automated deployment pipeline

**Live site**: [https://egohygiene.github.io/ubi/](https://egohygiene.github.io/ubi/)

---

## Local Development

### Prerequisites

```bash
# Install dependencies
pip install mkdocs mkdocs-material
```

### Commands

```bash
# Serve documentation locally with live reload
mkdocs serve

# Build static site
mkdocs build

# Deploy to GitHub Pages (manual)
mkdocs gh-deploy
```

### File Structure

```
.
├── mkdocs.yml              # MkDocs configuration
├── docs/                   # Documentation source files
│   ├── index.md           # Home page
│   ├── architecture.md    # Architecture documentation
│   ├── examples.md        # Examples and use cases
│   ├── getting-started/   # Getting started guides
│   ├── security/          # Security documentation
│   └── ...
└── site/                   # Built documentation (gitignored)
```

---

## GitHub Pages Configuration

### Enable GitHub Pages

1. Go to repository **Settings** → **Pages**
2. Under **Source**, select:
   - **Branch**: `gh-pages`
   - **Folder**: `/ (root)`
3. Click **Save**

The site will be available at: `https://egohygiene.github.io/ubi/`

### Automated Deployment

Documentation is automatically deployed when:

- Changes are pushed to `main` branch
- Changes affect:
  - `docs/**`
  - `mkdocs.yml`
  - `.github/workflows/docs.yml`
  - `pyproject.toml`

Workflow file: `.github/workflows/docs.yml`

### Manual Deployment

To deploy manually:

```bash
# From local machine
mkdocs gh-deploy
```

Or trigger the workflow:

1. Go to **Actions** → **📚 Build & Deploy Documentation**
2. Click **Run workflow**
3. Select branch and run

---

## Configuration

### mkdocs.yml

Main configuration file for MkDocs:

```yaml
site_name: UBI Documentation
site_url: https://egohygiene.github.io/ubi/
repo_name: egohygiene/ubi
repo_url: https://github.com/egohygiene/ubi

theme:
  name: material
  palette:
    # Light/dark mode toggle
  features:
    # Navigation, search, and UI features

plugins:
  - search

markdown_extensions:
  # Enhanced markdown features

nav:
  # Navigation structure
```

### Key Configuration Sections

**Theme features:**
- Navigation tabs and sections
- Search with highlighting
- Light/dark mode toggle
- Edit page links
- Mobile-responsive design

**Markdown extensions:**
- Code blocks with syntax highlighting
- Admonitions (notes, warnings, tips)
- Task lists
- Tables
- Emoji support
- Mermaid diagrams

**Navigation:**
- Manually defined in `mkdocs.yml`
- Organized by category
- Links to all main documentation pages

---

## Writing Documentation

### Markdown Syntax

MkDocs uses standard Markdown with extensions:

**Admonitions:**

```markdown
!!! note
    This is a note admonition.

!!! warning
    This is a warning admonition.

!!! tip
    This is a tip admonition.
```

**Code blocks:**

```markdown
\`\`\`python title="example.py"
def hello_world():
    print("Hello, World!")
\`\`\`
```

**Tabs:**

```markdown
=== "Tab 1"
    Content for tab 1

=== "Tab 2"
    Content for tab 2
```

### Best Practices

1. **Test locally** before pushing:
   ```bash
   mkdocs serve
   ```

2. **Use relative links** for internal docs:
   ```markdown
   [Architecture](architecture.md)
   [Examples](examples.md)
   ```

3. **Add new pages to navigation** in `mkdocs.yml`:
   ```yaml
   nav:
     - Home: index.md
     - New Page: new-page.md
   ```

4. **Use descriptive titles** in frontmatter:
   ```markdown
   # Page Title
   
   Brief introduction...
   ```

5. **Include code examples** where appropriate

6. **Keep pages focused** - one topic per page

---

## Troubleshooting

### Build Failures

**Issue:** `mkdocs build` fails

**Solution:**
- Check `mkdocs.yml` syntax
- Verify all files referenced in `nav` exist
- Check for broken internal links
- Review error messages for specific issues

### GitHub Pages Not Updating

**Issue:** Changes not appearing on live site

**Solution:**
1. Check GitHub Actions workflow status
2. Verify `gh-pages` branch was updated
3. Clear browser cache
4. Check GitHub Pages settings
5. Review workflow logs for errors

### Local Build Works, CI Fails

**Issue:** Build succeeds locally but fails in CI

**Solution:**
- Ensure dependencies are in `pyproject.toml`
- Check Python version compatibility
- Review CI workflow logs
- Test with same Python version as CI

### Links Not Working

**Issue:** Internal links broken on live site

**Solution:**
- Use relative links: `[Page](page.md)` not `[Page](/page.md)`
- Ensure linked files exist in `docs/`
- Check `nav` configuration in `mkdocs.yml`
- Test with `mkdocs serve` locally

---

## Maintenance

### Updating Dependencies

**Check for updates:**

```bash
pip list --outdated | grep mkdocs
```

**Update dependencies:**

```bash
# Update MkDocs
pip install --upgrade mkdocs mkdocs-material

# Update pyproject.toml if needed
```

**Test after updates:**

```bash
mkdocs build
mkdocs serve
```

### Adding New Pages

1. Create new `.md` file in `docs/`
2. Add to `nav` in `mkdocs.yml`
3. Test locally
4. Commit and push

### Changing Theme

To customize the Material theme:

**Colors:**

```yaml
theme:
  palette:
    primary: indigo
    accent: indigo
```

**Features:**

```yaml
theme:
  features:
    - navigation.tabs
    - navigation.sections
    - search.highlight
```

See [Material for MkDocs documentation](https://squidfunk.github.io/mkdocs-material/) for more options.

---

## Resources

- **MkDocs**: https://www.mkdocs.org/
- **Material for MkDocs**: https://squidfunk.github.io/mkdocs-material/
- **GitHub Pages**: https://pages.github.com/
- **Markdown Guide**: https://www.markdownguide.org/

---

## Getting Help

If you encounter issues with the documentation site:

1. Check this guide
2. Review [MkDocs documentation](https://www.mkdocs.org/)
3. Check [Material theme docs](https://squidfunk.github.io/mkdocs-material/)
4. Open an issue on GitHub
5. Ask in discussions

---

**Last Updated**: 2025-12-13
