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

SBOMs are generated for **each UBI variant** during the publish workflow and are available in multiple ways:

#### 1. GitHub Release Assets

Download pre-generated SBOMs from any release:

```bash
# Set your desired version
VERSION="0.1.5"

# Download SBOM for base variant
curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-base-sbom-${VERSION}.spdx.json"

# Download SBOM for python variant
curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-python-sbom-${VERSION}.spdx.json"

# Download SBOM for node variant
curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-node-sbom-${VERSION}.spdx.json"

# Download SBOM for full variant
curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-full-sbom-${VERSION}.spdx.json"

# Download SBOM for minimal variant
curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-minimal-sbom-${VERSION}.spdx.json"
```

**Benefits:**
- ✅ Pre-generated at build time (no need to generate locally)
- ✅ Permanently archived with each release
- ✅ Cryptographically tied to image digest
- ✅ Supports compliance and audit requirements

#### 2. GitHub Workflow Artifacts

Download from workflow runs (90-day retention):
- Navigate to: <https://github.com/egohygiene/ubi/actions/workflows/publish.yml>
- Select a workflow run
- Download artifacts: `ubi-{variant}-sbom-{version}`

#### 3. Generate Locally

Generate SBOMs on-demand for any variant:

   ```bash
   # Install Syft
   brew install syft

   # Set your desired version
   VERSION="0.1.5"

   # Generate SBOM for base variant
   syft "ghcr.io/egohygiene/ubi:${VERSION}" -o spdx-json > "ubi-base-sbom-${VERSION}.json"

   # Generate SBOM for python variant
   syft "ghcr.io/egohygiene/ubi:${VERSION}-python" -o spdx-json > "ubi-python-sbom-${VERSION}.json"

   # View summary (table format)
   syft "ghcr.io/egohygiene/ubi:${VERSION}" -o table

   # Generate in CycloneDX format (alternative to SPDX)
   syft "ghcr.io/egohygiene/ubi:${VERSION}" -o cyclonedx-json > "ubi-base-sbom-${VERSION}.cyclonedx.json"
   ```

### SBOM Use Cases

- **Vulnerability Tracking**: Cross-reference with CVE databases
- **License Compliance**: Identify all OSS licenses
- **Supply Chain Risk**: Audit third-party components
- **Regulatory Compliance**: Meet NTIA minimum elements
- **Incident Response**: Quickly identify affected components

### Verifying and Consuming SBOMs

#### Validate SBOM Structure

```bash
# Install SPDX tools
pip install spdx-tools

# Set your version
VERSION="0.1.5"

# Validate SBOM structure
pyspdxtools -i "ubi-base-sbom-${VERSION}.spdx.json"

# Extract package list
jq '.packages[] | .name' "ubi-base-sbom-${VERSION}.spdx.json"
```

#### Scan SBOM for Vulnerabilities

```bash
# Set your version
VERSION="0.1.5"

# Use Grype to scan SBOM for vulnerabilities
grype "sbom:./ubi-base-sbom-${VERSION}.spdx.json"

# Use Trivy to scan SBOM
trivy sbom "ubi-base-sbom-${VERSION}.spdx.json" --severity HIGH,CRITICAL
```

#### Compare Variants

```bash
# Set your version
VERSION="0.1.5"

# Compare package counts between variants
echo "Base packages: $(jq '.packages | length' "ubi-base-sbom-${VERSION}.spdx.json")"
echo "Python packages: $(jq '.packages | length' "ubi-python-sbom-${VERSION}.spdx.json")"
echo "Full packages: $(jq '.packages | length' "ubi-full-sbom-${VERSION}.spdx.json")"

# Find packages unique to python variant
comm -13 \
  <(jq -r '.packages[].name' "ubi-base-sbom-${VERSION}.spdx.json" | sort) \
  <(jq -r '.packages[].name' "ubi-python-sbom-${VERSION}.spdx.json" | sort)
```

#### Integrate with CI/CD

```yaml
# Example GitHub Action to verify SBOM in downstream projects
- name: Download and verify UBI SBOM
  run: |
    VERSION="0.1.5"
    curl -L -O "https://github.com/egohygiene/ubi/releases/download/${VERSION}/ubi-base-sbom-${VERSION}.spdx.json"
    
    # Scan for vulnerabilities
    grype sbom:./ubi-base-sbom-${VERSION}.spdx.json --fail-on high
```

### SBOM Best Practices

1. **Pin Specific Versions**: Use version-specific SBOMs, not `latest`
2. **Archive SBOMs**: Store with your own release artifacts alongside derived images
3. **Regular Review**: Periodically audit components in your base image
4. **Automate Checks**: Integrate SBOM vulnerability scanning into CI/CD
5. **Variant Selection**: Choose the minimal variant needed to reduce supply chain risk
6. **Share with Consumers**: Make SBOMs available to your downstream users
7. **Track Changes**: Monitor SBOM differences between versions to understand what changed

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

### 6. SLSA Build Provenance Attestation

**Status**: ✅ Implemented

UBI generates SLSA build provenance attestations for every published image:

- **SLSA Level**: Level 2+ compliance
- **Attestation Format**: In-toto SLSA Provenance (v1.0)
- **Generation**: GitHub Actions `actions/attest-build-provenance@v2`
- **Storage**: GitHub attestation registry and GHCR
- **Coverage**: All image variants (base, minimal, python, node, full)

**How It Works:**

Each image variant (base, minimal, python, node, full) is built separately with its own Dockerfile and receives its own unique attestation. The attestation is cryptographically linked to the image digest, so any tag pointing to that digest can be verified.

**What's Included:**

- Build environment metadata (GitHub Actions runner details)
- Source repository and commit SHA
- Workflow identity and build parameters
- Image digest and subject information
- Cryptographic signature via Sigstore

**Verification:**

```bash
# Install GitHub CLI
brew install gh  # macOS
# or follow instructions at https://cli.github.com/

# Verify attestation for base image (latest)
gh attestation verify oci://ghcr.io/egohygiene/ubi:latest --owner egohygiene

# Verify attestation for a specific variant
gh attestation verify oci://ghcr.io/egohygiene/ubi:latest-python --owner egohygiene
gh attestation verify oci://ghcr.io/egohygiene/ubi:0.1.5-node --owner egohygiene

# View full attestation details in JSON
gh attestation verify oci://ghcr.io/egohygiene/ubi:latest --owner egohygiene --format json | jq
```

**Benefits:**

- ✅ Verifiable build provenance for supply chain security
- ✅ Proof that images were built by authorized GitHub workflows
- ✅ Tamper-proof cryptographic link between source and artifact
- ✅ Compliance with SLSA framework requirements
- ✅ Enhanced transparency for downstream consumers

---

## Future Enhancements

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
- [SLSA Framework](https://slsa.dev/) - Supply-chain Levels for Software Artifacts
- [GitHub Attestations](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds) - Build provenance documentation

### Tools

- [Trivy](https://github.com/aquasecurity/trivy) - Vulnerability scanner
- [Syft](https://github.com/anchore/syft) - SBOM generator
- [Cosign](https://github.com/sigstore/cosign) - Container image signing
- [GitHub CLI](https://cli.github.com/) - Attestation verification
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
