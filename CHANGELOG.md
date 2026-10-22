# Changelog

All notable changes to the Varbase AI VDB: Milvus recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2026-10-12
### Changed
- Removed `tests/verify.php`: the repository now holds no PHP file. CI runs the same no-key checks inline
  (`drush php:eval` in `.github/workflows/ci.yml`), and the lint job fails on any `.php`, `.module`, `.install` or
  `.inc` file (#7).

### Checked
- CI on 1.0.x (https://github.com/Vardot/varbase_ai_vdb_milvus/actions/runs/38238522390): the lint job found no PHP file, the recipe applied twice, the inline
  check printed `RESULT: PASS` and the functional tests passed.

## [1.0.1] - 2026-10-11
### Added
- Functional tests in `tests/features`, run in CI after `tests/verify.php`: Playwright and Cucumber
  through `@vardot/varbase-e2e`, in Chromium, against the site CI builds. They check the admin pages the
  recipe sets up and that anonymous visitors cannot reach them.
### Changed
- README: link to the renamed Varbase AI Search Base and Varbase AI Answers Base repositories. No change
  to the recipe.

## [1.0.0] - 2026-10-08
### Added
- The recipe: installs Key, AI, AI Search and the Milvus VDB provider, creates the `milvus_api_key` Key that reads
  `MILVUS_API_KEY`, and sets the server, port and Key from its inputs. The server and port default to
  `MILVUS_SERVER` and `MILVUS_PORT` from the environment, then to the DDEV service.
- `ddev/docker-compose.milvus.yaml`: Milvus 2.6 for DDEV, with no host port.
- `tests/verify.php`: an end-to-end check of the provider that needs no AI key.
- GitHub Actions CI: lint, then Milvus 2.6.21 from `tests/ci/docker-compose.milvus.yml` and a Drupal 11.4 site
  that applies the recipe with the `MILVUS_SERVER` and `MILVUS_PORT` inputs from the environment, applies it again
  and runs `tests/verify.php`.
- README in the Varbase AI recipe style, `AGENTS.md`, `LICENSE`, `logo.png`, composer metadata, and the Vardot
  issue and pull request templates.

### Changed
- `ddev/docker-compose.milvus.yaml` is now one container: Milvus standalone with embedded etcd and local storage
  (`ETCD_USE_EMBED`, `COMMON_STORAGETYPE=local`), Milvus's own `standalone_embed.sh` setup. The `minio/minio`
  image can no longer be pulled from Docker Hub or quay.io, so the old three-container setup (Milvus, etcd, MinIO)
  could not start on a new machine. Existing DDEV projects keep working on their cached images. A project that
  switches to the new file starts with an empty Milvus, so it must create the `varbase_ai_search` database again
  and re-index.

### Fixed
- Require `drupal/search_api`. The recipe installs AI Search, which needs it, so on a site without Search API
  the apply stopped with "The following extensions are missing". Found by the new CI.
- `tests/verify.php` builds its Search API server and index in memory. It used to copy the site's own `database`
  server and `content` index, which only Varbase sites have.

[Unreleased]: https://github.com/Vardot/varbase_ai_vdb_milvus/compare/1.0.2...1.0.x
[1.0.2]: https://github.com/Vardot/varbase_ai_vdb_milvus/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/Vardot/varbase_ai_vdb_milvus/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/Vardot/varbase_ai_vdb_milvus/releases/tag/1.0.0
