# Security Policy

## 🔒 Reporting a Vulnerability

The Ego Hygiene team takes security seriously. We appreciate your efforts to responsibly disclose your findings and will make every effort to acknowledge your contributions.

### How to Report

If you discover a security vulnerability in UBI, please report it through one of the following channels:

#### Preferred: GitHub Security Advisories

Report vulnerabilities privately through GitHub's Security Advisory feature:

**[Report a vulnerability →](https://github.com/egohygiene/ubi/security/advisories/new)**

This allows us to discuss the issue privately and coordinate a fix before public disclosure.

#### Alternative: Email

For sensitive issues or if you prefer email communication:

- **Email**: [security@egohygiene.com](mailto:security@egohygiene.com)
- **Subject**: Include `[SECURITY]` and a brief description (e.g., `[SECURITY] Privilege escalation in UBI base image`)

### What to Include

Please provide as much detail as possible:

- **Description**: Clear explanation of the vulnerability
- **Impact**: Potential security impact and affected versions
- **Steps to Reproduce**: Detailed steps or proof-of-concept
- **Environment**: Version numbers, configurations, or specific scenarios
- **Suggested Fix**: If you have recommendations (optional)

---

## 📦 Supported Versions

UBI follows [Semantic Versioning (SemVer)](https://semver.org/). We provide security updates for the following versions:

| Version | Supported          | Status                |
| ------- | ------------------ | --------------------- |
| 0.1.x   | :white_check_mark: | Current stable series |
| < 0.1.0 | :x:                | No longer supported   |

### Update Cadence

- **Security patches**: Released as soon as fixes are available (PATCH version bump)
- **Dependency updates**: Monitored continuously via Trivy and Dependabot
- **Base image updates**: Evaluated quarterly or when critical security patches are released
- **EOL policy**: Only the latest minor version receives security updates

**Recommendation**: Always use the latest version (`latest` tag) or pin to a specific version for production deployments.

---

## 🛡️ Security Tools Used

UBI employs multiple layers of automated security scanning:

### Container Vulnerability Scanning

**[Trivy](https://github.com/aquasecurity/trivy)** scans the UBI container for known vulnerabilities:

- **Runs on**: Pull requests, pushes to main, and weekly (every Monday at 00:00 UTC)
- **Scans for**: OS package vulnerabilities, known CVEs from the National Vulnerability Database (NVD)
- **Severity threshold**: Fails CI/CD if CRITICAL or HIGH vulnerabilities are detected
- **Results**: Uploaded to [GitHub Security Tab (Code Scanning)](https://github.com/egohygiene/ubi/security/code-scanning)

View scan results: [Trivy Scan Workflow](https://github.com/egohygiene/ubi/actions/workflows/trivy-scan.yml)

### Dependency Management

- **Base Image Pinning**: Upstream DevContainers base image is pinned with a digest for reproducibility
- **Automated Updates**: Regular monitoring of upstream base image releases for security patches
- **Supply Chain Security**: All dependencies are tracked and auditable

### GitHub Security Features

- **[Security Advisories](https://github.com/egohygiene/ubi/security/advisories)**: Private vulnerability reporting and coordination
- **[Security Tab](https://github.com/egohygiene/ubi/security)**: Centralized view of security alerts and scanning results
- **[Code Scanning](https://github.com/egohygiene/ubi/security/code-scanning)**: Automated vulnerability detection via Trivy

---

## ⏱️ Response Timeline

We are committed to addressing security issues promptly:

| Stage                | Timeline              |
| -------------------- | --------------------- |
| **Initial Response** | Within 48 hours       |
| **Triage**           | Within 5 business days|
| **Fix Development**  | Depends on severity   |
| **Patch Release**    | - Critical: 1-3 days<br>- High: 1-2 weeks<br>- Medium: 2-4 weeks<br>- Low: Next scheduled release |
| **Public Disclosure**| After patch is released, or 90 days from report (whichever comes first) |

**Note**: Timelines may vary based on complexity, severity, and available resources. We will keep you informed throughout the process.

---

## 🤝 Responsible Disclosure Policy

We kindly ask security researchers to:

1. **Report privately first**: Use GitHub Security Advisories or email before public disclosure
2. **Allow time for a fix**: Give us a reasonable timeframe to address the issue (90 days standard)
3. **Avoid exploitation**: Do not exploit the vulnerability beyond what's necessary to demonstrate it
4. **Respect privacy**: Do not access, modify, or delete data belonging to others
5. **Coordinate disclosure**: Work with us on the timing and content of public disclosure

### Recognition

- We will publicly acknowledge your responsible disclosure (unless you prefer to remain anonymous)
- Contributors who report valid vulnerabilities may be listed in our [CHANGELOG.md](./CHANGELOG.md)
- We do not currently offer a bug bounty program

---

## 📞 Security Contacts

- **Primary Contact**: [security@egohygiene.com](mailto:security@egohygiene.com)
- **GitHub Security Advisories**: [Report a vulnerability](https://github.com/egohygiene/ubi/security/advisories/new)
- **General Inquiries**: [Issues](https://github.com/egohygiene/ubi/issues) (for non-security-related questions)
- **Discussions**: [Discussions](https://github.com/egohygiene/ubi/discussions) (for general topics)

---

## 🔗 Additional Resources

- **Trivy Documentation**: [https://aquasecurity.github.io/trivy/](https://aquasecurity.github.io/trivy/)
- **CVE Database**: [https://nvd.nist.gov/](https://nvd.nist.gov/)
- **CNCF Security Best Practices**: [https://www.cncf.io/blog/2021/10/06/security-best-practices-for-cloud-native-applications/](https://www.cncf.io/blog/2021/10/06/security-best-practices-for-cloud-native-applications/)
- **GitHub Security Advisories**: [https://docs.github.com/en/code-security/security-advisories](https://docs.github.com/en/code-security/security-advisories)

---

## 📜 Security Policy Updates

This security policy may be updated periodically. Changes will be documented in commit history. Last updated: 2025-12-12.

---

**Thank you for helping keep UBI and the Ego Hygiene community secure! 🙏**
