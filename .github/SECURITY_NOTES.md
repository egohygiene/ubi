# Security Notes for semantic-release Dependencies

## Known Issues

### Transitive Dependency: glob vulnerability in @semantic-release/npm

**Status**: Acknowledged - Not Exploitable

**Details**:
- **Package**: `glob` (v10.2.0 - v10.4.5)
- **Vulnerability**: [GHSA-5j98-mcp5-4vw2](https://github.com/advisories/GHSA-5j98-mcp5-4vw2)
- **Severity**: HIGH
- **Description**: Command injection via glob CLI `-c/--cmd` flag with `shell:true`
- **Affected Path**: `semantic-release` → `@semantic-release/npm` → `npm` (bundled) → `glob`

**Why This Doesn't Affect UBI**:

1. **Not Used**: UBI does not publish to npm registry. The `@semantic-release/npm` plugin is a transitive dependency but is not configured in `.releaserc.yml`.

2. **CLI-Only Vulnerability**: This vulnerability only affects the `glob` command-line interface when used with the `-c/--cmd` flag. semantic-release uses glob programmatically, not via CLI.

3. **Bundled Dependency**: The vulnerable `glob` is bundled within `npm` package which is itself bundled in `@semantic-release/npm`. It cannot be updated without updating the entire plugin chain.

**Mitigation**:
- We do not use npm publishing functionality
- We explicitly excluded `@semantic-release/npm` from our configuration
- The vulnerability only affects CLI usage, not programmatic usage

**Future Action**:
Monitor for updates to `@semantic-release/npm` that include a patched version of glob (v10.5.0+).

---

## Verification

All direct dependencies have been checked against the GitHub Advisory Database:

```bash
✅ semantic-release@24.2.9 - No vulnerabilities
✅ @semantic-release/changelog@6.0.3 - No vulnerabilities
✅ @semantic-release/commit-analyzer@13.0.1 - No vulnerabilities
✅ @semantic-release/exec@6.0.3 - No vulnerabilities
✅ @semantic-release/git@10.0.1 - No vulnerabilities
✅ @semantic-release/github@11.0.6 - No vulnerabilities
✅ @semantic-release/release-notes-generator@14.1.0 - No vulnerabilities
```

Last updated: 2025-12-13
