# Changelog

All notable changes to the UBI (Universal Base Image) project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- CHANGELOG.md file following Keep a Changelog format
- PR template reminding contributors to update VERSION and CHANGELOG
- GitHub Actions workflow to validate CHANGELOG updates
- README links to CHANGELOG for release history

### Changed

### Deprecated

### Removed

### Fixed

### Security

## 0.1.2 - 2025-02-11

### Changed

- Version bump and release pipeline validation.

## 0.1.1 - 2025-02-11

### Added

- Initial working version of the automated bump → tag → publish pipeline.
- GitHub Container Registry image publishing for tagged versions.

## 0.1.0 - 2024-12-11

### Added

- Initial release of UBI (Universal Base Image)
- XDG-aligned filesystem with `/opt/universal/*` hierarchy
- Standardized environment variables for reproducible builds
- Pre-configured locale, timezone, and editor settings
- Python, Node.js, and Rust runtime configurations
- Telemetry opt-outs for privacy
- Configurable build arguments for customization
- GitHub Container Registry (GHCR) distribution
- Semantic versioning with VERSION file
- Automated build and publish workflow via GitHub Actions

[Unreleased]: https://github.com/egohygiene/ubi/compare/0.1.2...HEAD
