# AGENTS.md

Guidance for AI coding agents working on the Varbase AI VDB: Milvus recipe.

This is a **private** recipe on GitHub (`Vardot/varbase_ai_vdb_milvus`), not a drupal.org project. Issues,
pull requests and CI all live on GitHub.

## Before you start

- **`CHANGELOG.md`**: what changed in each release, newest first. Read it before proposing a change.
- **Pull requests and their discussions** on
  [github.com/Vardot/varbase_ai_vdb_milvus](https://github.com/Vardot/varbase_ai_vdb_milvus/pulls): the
  reasoning behind recent changes.
- **Issues** on [github.com/Vardot/varbase_ai_vdb_milvus/issues](https://github.com/Vardot/varbase_ai_vdb_milvus/issues):
  the Problem/Motivation and Proposed resolution for each change.
- **`README.md`**: what was checked, what was not, and the known issues in the provider.

## When you make a change

- One issue and one pull request per change. The PR says `Closes #<issue>` and ends with the Checkpoints list
  from `.github/pull_request_template.md`.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- CI must be green before merging: `.github/workflows/ci.yml` lints the repository, then starts Milvus 2.6 from
  `tests/ci/docker-compose.milvus.yml`, applies the recipe on a real Drupal 11.4 site, applies it again and runs
  The CI recipe check.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file. The no-key checks run inline in
  `.github/workflows/ci.yml` (`drush php:eval`), and the lint job fails on any PHP file.
- Never store a token in configuration. The `milvus_api_key` Key reads it from the `MILVUS_API_KEY` environment
  variable, and a server that differs per environment is set in `settings.php` from environment variables.
- Keep `ddev/docker-compose.milvus.yaml` and `tests/ci/docker-compose.milvus.yml` on the same image and setup. The
  DDEV Milvus has authorization off, so it never publishes a host port.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment
  (`1.0.0`) and are never moved once pushed.
