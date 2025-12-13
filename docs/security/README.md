# Security Documentation

This directory contains security-related documentation for the UBI project.

## Contents

- **[privileged-mode.md](./privileged-mode.md)** - Analysis and documentation of the privileged mode investigation in the devcontainer configuration. Explains why `privileged: true` was removed and the security implications.

## Security Best Practices

The UBI project follows security best practices including:

- **Principle of Least Privilege**: Containers run with minimal required permissions
- **Container Isolation**: Standard container security boundaries are maintained
- **Pinned Base Images**: Using specific versions and digests for reproducibility
- **Regular Security Scanning**: Trivy scans integrated into CI/CD pipeline
- **Security Audits**: Regular security audits and follow-up actions

## Reporting Security Issues

Please refer to the main [SECURITY.md](../../SECURITY.md) file in the repository root for information on how to report security vulnerabilities.

## Related Documentation

- [DevContainer Configuration](../../.devcontainer/)
- [CI/CD Workflows](../../.github/workflows/)
- [Security Audit Report](../../audit/)
