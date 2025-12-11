# Changelog

All notable changes to the UBI (Universal Base Image) project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 0.1.2 - 2025-02-11
### Changed
- Version bump and changelog automation testing.

## 0.1.1 - 2025-02-11
### Added
- Functional automated bump → tag → publish pipeline.
- GHCR publishing for versioned UBI images.

## 0.1.0 - 2024-12-11
### Added
- Initial release of UBI (Universal Base Image)
- XDG-aligned filesystem with `/opt/universal/*` hierarchy
- Standardized environment variables for reproducible builds
- Pre-configured locale, timezone, and editor settings
- Telemetry opt-outs for privacy
- Build arguments for customization
- GHCR distribution
- Versioning pipeline with VERSION file
- Initial CHANGELOG

[Unreleased]: https://github.com/egohygiene/ubi/compare/0.1.2...HEAD
[0.1.2]: https://github.com/egohygiene/ubi/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/egohygiene/ubi/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/egohygiene/ubi/tree/0.1.0
