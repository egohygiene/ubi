# Security Overview

This document provides an overview of UBI's security practices, threat model, and security-related configurations.

---

## Table of Contents

- [Security Philosophy](#security-philosophy)
- [Threat Model](#threat-model)
- [Container Security](#container-security)
- [Vulnerability Scanning](#vulnerability-scanning)
- [Software Bill of Materials (SBOM)](#software-bill-of-materials-sbom)
- [Supply Chain Security](#supply-chain-security)
- [Future Enhancements](#future-enhancements)
- [Reporting Vulnerabilities](#reporting-vulnerabilities)

---

## Security Philosophy

UBI follows a defense-in-depth approach with multiple layers of security:

1. **Principle of Least Privilege**: Run with minimal necessary permissions
2. **Transparency**: SBOM generation for full supply chain visibility
3. **Proactive Scanning**: Automated vulnerability detection
4. **Reproducibility**: Pinned dependencies prevent supply chain attacks
5. **Regular Updates**: Keep base image and dependencies current

**Key Principle**: Security is a continuous process, not a one-time configuration.

---

## Threat Model

### Assets to Protect

- **Host System**: The machine running the container
- **Container Runtime**: Docker daemon and orchestration layer
- **Source Code**: Developer's projects in `/workspace`
- **Credentials**: Git tokens, API keys, SSH keys
- **Build Artifacts**: Compiled code and dependencies

### Threats Considered

| Threat | Mitigation | Status |
|--------|-----------|--------|
| Container escape | No privileged mode, standard isolation | ✅ Implemented |
| Supply chain attack | Pinned base image with digest | ✅ Implemented |
| Vulnerable dependencies | Automated Trivy scanning | ✅ Implemented |
| Malicious packages | SBOM tracking, manual review | ✅ Implemented |
| Credential theft | Non-root user, no credential storage | ✅ Implemented |
| Host resource exhaustion | Standard container limits (configurable) | ⚠️ User responsibility |
| Malicious container images | Cosign keyless signing | ✅ Implemented |

### Out of Scope

The following are explicitly **not** in scope for UBI's threat model:

- **Physical security** of the host machine
- **Network security** outside the container (firewall rules, etc.)
- **Application security** in projects built on UBI
- **Secrets management** (use dedicated tools like HashiCorp Vault)

---

## Container Security

### No Privileged Mode

**Status**: ✅ Removed and verified unnecessary

UBI does **not** require or use privileged mode (`privileged: true`). This provides:

- Standard container isolation maintained
- Limited kernel capabilities (only required ones)
- AppArmor/SELinux profiles enforced
- Reduced attack surface
- Better compliance with security standards

**Details**: See [Privileged Mode Analysis](./security/privileged-mode.md) for the full investigation and decision rationale.

### Non-Root User

UBI runs as the `vscode` user by default, not root:

```dockerfile
USER vscode
```

**Benefits:**

- Limits damage from container escape
- Prevents accidental system modifications
- Follows best practice for development containers

**Note:** Some operations during image build require root, but the final runtime user is `vscode`.

### Minimal Base Image

UBI uses Microsoft's DevContainers base image, which:

- Is actively maintained by Microsoft
- Receives regular security updates
- Has a small attack surface
- Is widely used and audited

### Security Context

When running UBI, consider applying these Docker security options:

```yaml
# In docker-compose.yml
services:
  development:
    security_opt:
      - no-new-privileges:true  # Prevent privilege escalation
    cap_drop:
      - ALL                     # Drop all capabilities
    cap_add:
      - NET_BIND_SERVICE       # Add back only what's needed
```

**Note:** UBI doesn't enforce these by default to maintain flexibility, but they're recommended for production-like environments.

---

## Vulnerability Scanning

UBI uses [Trivy](https://github.com/aquasecurity/trivy) for automated container vulnerability scanning.

### What Trivy Scans

- **OS packages**: Debian packages from base image
- **Application dependencies**: Any installed libraries
- **Known CVEs**: Cross-references with vulnerability databases
- **Misconfigurations**: Docker and Kubernetes security issues

### When Scanning Occurs

| Trigger | Schedule | Purpose |
|---------|----------|---------|
| **Pull Requests** | On every PR | Catch vulnerabilities before merge |
| **Push to main** | After each merge | Verify security post-merge |
| **Weekly Schedule** | Monday 00:00 UTC | Continuous monitoring for new CVEs |
| **Manual Dispatch** | On-demand | Ad-hoc security checks |

### Severity Levels

Trivy categorizes vulnerabilities by severity:

| Severity | Action | Build Impact |
|----------|--------|--------------|
| **CRITICAL** | Fix immediately | ❌ Fails build |
| **HIGH** | Fix within 30 days | ❌ Fails build |
| **MEDIUM** | Fix within 90 days | ⚠️ Warning only |
| **LOW** | Fix when convenient | ℹ️ Informational |
| **NEGLIGIBLE** | No action needed | ℹ️ Informational |

**Build Policy:** CI/CD pipeline fails if CRITICAL or HIGH severity vulnerabilities are detected.

### Viewing Scan Results

1. **GitHub Security Tab:**
   - Navigate to: <https://github.com/egohygiene/ubi/security/code-scanning>
   - View all detected vulnerabilities
   - Filter by severity, status, and date

2. **Workflow Artifacts:**
   - Go to: <https://github.com/egohygiene/ubi/actions/workflows/trivy-scan.yml>
   - Download detailed report from artifact

3. **Pull Request Comments:**
   - Trivy automatically comments on PRs with findings

### Running Trivy Locally

```bash
# Install Trivy
brew install trivy  # macOS
# or
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update && sudo apt-get install trivy

# Scan UBI image
trivy image --severity CRITICAL,HIGH ghcr.io/egohygiene/ubi:latest

# Generate report
trivy image --format json --output trivy-report.json ghcr.io/egohygiene/ubi:latest
```

### Addressing Vulnerabilities

When Trivy detects vulnerabilities:

1. **Assess Impact:**
   - Is the vulnerable package actually used in UBI?
   - Is there an exploit available?
   - What's the attack vector?

2. **Determine Remediation:**
   - **Update base image**: Check if newer version has fix
   - **Update packages**: `apt-get upgrade` specific packages
   - **Remove package**: If not needed, remove it
   - **Accept risk**: Document why and track for future fix

3. **Verify Fix:**

   ```bash
   # Rebuild and rescan
   docker build -f .devcontainer/Dockerfile -t ubi:test .
   trivy image --severity CRITICAL,HIGH ubi:test
   ```

4. **Document:**
   - Update CHANGELOG.md with security fixes
   - Bump version appropriately (PATCH for security fixes)
   - Reference CVE IDs in commit messages

---

## Software Bill of Materials (SBOM)

UBI generates an SBOM for every published image, providing full transparency into components.

### What's in the SBOM?

- **Package inventory**: All installed packages with versions
- **Dependencies**: Transitive dependency graph
- **Licenses**: Open source license information
- **Relationships**: How components relate to each other
- **Metadata**: Build information, timestamps, checksums

### SBOM Format

- **Standard**: SPDX 2.3 (Software Package Data Exchange)
- **Format**: JSON (machine-readable)
- **Tool**: Syft by Anchore

### Accessing SBOMs

1. **GitHub Artifacts:**
   - Published with every release
   - 90-day retention
   - Download from workflow runs

2. **Generate Locally:**

   ```bash
   # Install Syft
   brew install syft

   # Generate SBOM
   syft ghcr.io/egohygiene/ubi:0.1.5 -o spdx-json > ubi-sbom.json

   # View summary
   syft ghcr.io/egohygiene/ubi:0.1.5 -o table
   ```

### SBOM Use Cases

- **Vulnerability Tracking**: Cross-reference with CVE databases
- **License Compliance**: Identify all OSS licenses
- **Supply Chain Risk**: Audit third-party components
- **Regulatory Compliance**: Meet NTIA minimum elements
- **Incident Response**: Quickly identify affected components

### SBOM Best Practices

1. **Archive SBOMs**: Store with release artifacts
2. **Regular Review**: Periodically audit components
3. **Automate Checks**: Integrate SBOM scanning into CI/CD
4. **Share with Consumers**: Make available to downstream users

---

## Supply Chain Security

UBI implements multiple supply chain security measures:

### 1. Base Image Pinning

The base image is pinned with a cryptographic digest:

```dockerfile
FROM mcr.microsoft.com/devcontainers/base:2.1.2@sha256:36751f1ee2f30745a649afc2b2061f321bacdaa0617159901fe6725b34c93df4
```

**Benefits:**

- ✅ Immutable - same digest always pulls identical image
- ✅ Tamper-proof - digest changes if image modified
- ✅ Reproducible - builds are deterministic
- ✅ Auditable - exact version is traceable

**Risks Mitigated:**

- Tag hijacking (someone overwrites `:2.1.2` tag)
- Man-in-the-middle attacks during pull
- Accidental upstream changes

### 2. Dependency Tracking

All dependencies are tracked via:

- SBOM generation (Syft)
- Vulnerability scanning (Trivy)
- Version pinning in Dockerfile (where applicable)

### 3. Secure Build Pipeline

GitHub Actions workflows use:

- Pinned action versions (e.g., `actions/checkout@v4`)
- Minimal permissions (principle of least privilege)
- Secrets management via GitHub Secrets
- Isolated build environments

### 4. Reproducible Builds

Every build is reproducible via:

- Git commit SHA tags (`sha-abc123`)
- Pinned base image digest
- Locked dependency versions
- Documented build process

### 5. Image Signing with Cosign

**Status**: ✅ Implemented

UBI images are cryptographically signed using [Sigstore Cosign](https://github.com/sigstore/cosign) with keyless signing:

```bash
# Verify signed image
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi:latest
```

**Benefits:**

- ✅ Cryptographic proof of authenticity
- ✅ Verification of image provenance
- ✅ Protection against supply chain attacks
- ✅ Keyless signing via GitHub OIDC (no key management)
- ✅ Transparency log backed by Sigstore Rekor
- ✅ Traceable to specific GitHub workflow runs

**How It Works:**

1. GitHub Actions workflow builds and pushes the image
2. Cosign signs the image digest using GitHub OIDC identity
3. Signature is stored in the container registry alongside the image
4. Signature is recorded in Sigstore's public transparency log
5. Anyone can verify the signature without needing access to private keys

**What Gets Signed:**

- All published tags (`latest`, version tags, SHA tags)
- Signed by digest, so signature covers all architectures (amd64, arm64)
- Signature metadata includes workflow identity and build context

**Verification Example:**

```bash
# Install Cosign
brew install cosign  # macOS
# or download from https://github.com/sigstore/cosign/releases

# Verify latest image
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi:latest

# Verify specific version
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi:0.1.5
```

### 6. Provenance (Future)

**Status**: 🔮 Planned

Future enhancement will include build provenance attestations:

- SLSA Level 3 compliance
- Signed provenance metadata
- Cryptographic verification of build steps

---

## Future Enhancements

### Build Attestations

**Status**: 🔮 Planned

Implement SLSA build attestations:

- Build environment metadata
- Build inputs and outputs
- Signed attestation bundles
- In-toto provenance format

### Security Policy as Code

**Status**: 🔮 Under consideration

Implement OPA (Open Policy Agent) policies:

- Enforce security best practices in CI
- Policy-based vulnerability acceptance
- Automated compliance checking

---

## Security Best Practices for UBI Users

When using UBI in your projects:

1. **Pin Specific Versions**: Use version tags, not `latest`

   ```json
   {
     "image": "ghcr.io/egohygiene/ubi:0.1.5"
   }
   ```

2. **Review SBOMs**: Understand what's in your base image

3. **Monitor Security Advisories**: Subscribe to repository notifications

4. **Keep Updated**: Regularly update to latest patched versions

5. **Scan Your Images**: Run Trivy on your derived images

   ```bash
   trivy image your-image:tag
   ```

6. **Don't Store Secrets**: Never commit credentials to images

7. **Use Security Context**: Apply appropriate Docker security options

8. **Limit Resources**: Set memory and CPU limits

   ```yaml
   services:
     dev:
       mem_limit: 4g
       cpus: '2.0'
   ```

---

## Reporting Vulnerabilities

### Security Policy

For details on reporting security vulnerabilities, see [SECURITY.md](../SECURITY.md).

### What to Report

- Security vulnerabilities in UBI
- Misconfigurations in Dockerfile or workflows
- Supply chain concerns
- Privilege escalation vectors
- Any security-relevant issues

### What Not to Report

- Vulnerabilities in base image (report to Microsoft)
- Application-level issues in your projects
- Generic Docker security questions

### Disclosure Process

1. **Private Disclosure**: Email security contact (see SECURITY.md)
2. **Assessment**: We evaluate severity and impact
3. **Fix Development**: Patch created and tested
4. **Coordinated Release**: Fix released with security advisory
5. **Public Disclosure**: Vulnerability disclosed after fix available

### Response SLA

| Severity | Initial Response | Fix Target |
|----------|-----------------|------------|
| Critical | 24 hours | 7 days |
| High | 48 hours | 30 days |
| Medium | 5 days | 90 days |
| Low | 10 days | Best effort |

---

## Security Resources

### Internal Documentation

- [Privileged Mode Analysis](./security/privileged-mode.md)
- [Architecture Overview](./architecture.md)
- [Release Process](./release-process.md)
- [Main Security Policy](../SECURITY.md)

### External Resources

- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Container Security](https://owasp.org/www-project-docker-top-10/)
- [NIST Container Security Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-190.pdf)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [SBOM Minimum Elements (NTIA)](https://www.ntia.gov/files/ntia/publications/sbom_minimum_elements_report.pdf)

### Tools

- [Trivy](https://github.com/aquasecurity/trivy) - Vulnerability scanner
- [Syft](https://github.com/anchore/syft) - SBOM generator
- [Cosign](https://github.com/sigstore/cosign) - Container signing (future)
- [Docker Bench Security](https://github.com/docker/docker-bench-security) - Security audit tool

---

## Security Changelog

Track security-related changes in UBI:

### v0.1.5 (2025-12-11)

- Initial security documentation created
- Trivy scanning workflow established
- SBOM generation implemented in publish workflow

### v0.1.4 (2025-12-11)

- Version synchronization fixes (no security changes)

### v0.1.3 (2025-12-11)

- Removed privileged mode from devcontainer
- Enhanced container isolation
- Documented security decision in privileged-mode.md

---

**Last Updated**: 2025-12-13  
**Next Review**: Quarterly or when significant changes occur  
**Maintained By**: Ego Hygiene Security Team
