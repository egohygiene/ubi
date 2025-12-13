# CHANGELOG Regex Pattern Fix

## Problem Summary

The original `bump-my-version` CHANGELOG rule used a regex pattern that caused duplicate version insertions and corrupted the CHANGELOG structure during automated version bumps.

## Root Cause Analysis

### The Problem Patterns

1. **Pattern: `\A## `** (Start of string)
   - **Issue**: CHANGELOG.md starts with `# Changelog\n\n`, not `## `
   - **Result**: Matches **0 times** - pattern is ineffective
   - **Impact**: No CHANGELOG updates occur

2. **Pattern: `^## `** (Start of line with MULTILINE)
   - **Issue**: Matches **every** version header in the file
   - **Result**: Matches **6+ times** for all version sections
   - **Impact**: Creates duplicate entries on each bump

### CHANGELOG Structure

```markdown
# Changelog

## 0.1.5 (2025-12-11)
[Compare the full difference.](...)

### Changed
- Some changes

## 0.1.4 (2025-12-11)
[Compare the full difference.](...)
```

## Solution

### Correct Pattern: `(# Changelog\n\n)## `

This pattern:
- Matches the literal string `# Changelog\n\n## `
- Captures `# Changelog\n\n` as group 1
- Targets **only** the first occurrence after the header
- Works regardless of how many version sections exist

### Configuration

```toml
[[tool.bumpversion.files]]
filename = "CHANGELOG.md"
regex = true
search = "(# Changelog\\n\\n)## "
replace = "\\g<1>## {new_version} ({now:%Y-%m-%d})\n[Compare the full difference.](https://github.com/egohygiene/ubi/compare/{current_version}...{new_version})\n\n## "
```

### How It Works

1. **Search**: Finds `# Changelog\n\n## ` at the start
2. **Capture**: Group 1 = `# Changelog\n\n`
3. **Replace**: Reconstructs with: `<captured header>` + `<new version>` + `## `
4. **Result**: New version inserted between header and first existing version

## Validation

### Test Results

✅ **Single bump**: Adds exactly 1 new section  
✅ **Multiple bumps**: No duplication across sequential versions  
✅ **Structure**: Preserves CHANGELOG format  
✅ **Position**: New version appears at top (after header)

### Dry-Run Output

```bash
$ bump-my-version bump patch --dry-run

File CHANGELOG.md: replace `(# Changelog\n\n)## ` with ...
  Found '(# Changelog\n\n)## ' at line 1: # Changelog

##
  Would change file CHANGELOG.md:
    *** before CHANGELOG.md
    --- after CHANGELOG.md
    ***************
    *** 1,4 ****
    --- 1,7 ----
      # Changelog
    +
    + ## 0.1.6 (2025-12-13)
    + [Compare the full difference.](https://github.com/egohygiene/ubi/compare/0.1.5...0.1.6)

      ## 0.1.5 (2025-12-11)
      [Compare the full difference.](https://github.com/egohygiene/ubi/compare/0.1.4...0.1.5)
```

## Verification Steps

To verify the fix works correctly:

```bash
# 1. Dry-run bump to see what would change
bump-my-version bump patch --dry-run --verbose

# 2. Check that only ONE occurrence is matched
# Look for: "Found '(# Changelog\n\n)## ' at line 1"

# 3. Verify the diff shows exactly one new section
# The diff should show: +3 lines (header + link + blank)

# 4. Confirm no duplication in subsequent bumps
# Run multiple dry-runs and verify each adds only 1 section
```

## Technical Details

### Regex Anchors Comparison

| Anchor | Meaning | Effect on CHANGELOG |
|--------|---------|-------------------|
| `\A` | Start of string | Doesn't match (file starts with `# Changelog`) |
| `^` | Start of line | Matches ALL version headers (with MULTILINE) |
| `(# Changelog\n\n)` | Literal match | Matches only the header + first version |

### Capture Groups

- **Group 0**: Full match `# Changelog\n\n## `
- **Group 1**: Captured `# Changelog\n\n`
- **`\g<1>`**: Backreference to restore the captured header

## Related Issues

- **Issue**: TASK-015 — Fix CHANGELOG Regex Pattern for bump-my-version
- **Priority**: P2
- **Labels**: bug, versioning, audit-followup

## References

- [bump-my-version documentation](https://github.com/callowayproject/bump-my-version)
- [Python regex documentation](https://docs.python.org/3/library/re.html)
- [Keep a Changelog](https://keepachangelog.com/) format

## Acceptance Criteria

- [x] pyproject.toml uses corrected search regex
- [x] Dry-run bump produces one correct new entry
- [x] No duplicate version blocks appear in CHANGELOG
- [x] Subsequent automated bumps behave consistently
