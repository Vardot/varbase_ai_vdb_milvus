# Changelog

All notable changes to the Varbase AI VDB: Milvus recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-beta2] - 2026-10-29
### Added
- A Claude Code agent and skill for applying and verifying the recipe ([#3633884](https://www.drupal.org/i/3633884)).

### Changed
- Disable Drupal CMS telemetry in CI ([#3633866](https://www.drupal.org/i/3633866)).
- Update the version badge to `1.0.0-beta2` in `README.md`.

## [1.0.0-beta1] - 2026-10-27
### Added
- Automated functional acceptance tests for the Milvus vector database setup and accessibility, run in CI on a fresh Varbase 11 site ([#3633130](https://www.drupal.org/i/3633130)).

### Changed
- Move the documentation to docs.varbase.vardot.com ([#3633027](https://www.drupal.org/i/3633027)).
- Install the Varbase Starter dev line in CI, which carries the search view fix for Drupal CMS Search 2.2.7.
- Update the version badge to `1.0.0-beta1` in `README.md`.

### Fixed
- Make Milvus the default vector database ([#3633121](https://www.drupal.org/i/3633121)).

## [1.0.0-alpha1] - 2026-10-24
### Added
- Initialize Varbase AI VDB: Milvus recipe ([#3632423](https://www.drupal.org/i/3632423)).
### Removed
- The GitHub Actions workflows and the `.github` templates: CI runs on git.drupalcode.org.

[Unreleased]: https://git.drupalcode.org/project/varbase_ai_vdb_milvus/-/compare/1.0.0-beta2...1.0.x
[1.0.0-beta2]: https://git.drupalcode.org/project/varbase_ai_vdb_milvus/-/compare/1.0.0-beta1...1.0.0-beta2
[1.0.0-beta1]: https://git.drupalcode.org/project/varbase_ai_vdb_milvus/-/compare/1.0.0-alpha1...1.0.0-beta1
[1.0.0-alpha1]: https://git.drupalcode.org/project/varbase_ai_vdb_milvus/-/tags/1.0.0-alpha1
