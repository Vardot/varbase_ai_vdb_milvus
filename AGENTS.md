# AGENTS.md

Guidance for AI coding agents working on the Varbase AI VDB: Milvus recipe.

This is a drupal.org project: [drupal.org/project/varbase_ai_vdb_milvus](https://www.drupal.org/project/varbase_ai_vdb_milvus).
Issues live in its [issue queue](https://www.drupal.org/project/issues/varbase_ai_vdb_milvus) and merge requests on
[git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_vdb_milvus). Its default branch is `1.0.x`; the
GitHub repository is a mirror and takes no issues or pull requests.

## Before you start

- **`CHANGELOG.md`**: what changed in each release, newest first. Read it before proposing a change.
- **Issues and merge requests** on drupal.org: the Problem/Motivation, Proposed resolution and the reasoning
  behind recent changes.
- **`README.md`**: what was checked, what was not, and the known issues in the provider.

## When you make a change

- One drupal.org issue and one issue-fork merge request per change, titled `<type>: #<issue> Summary`. The MR
  description ends with the Checkpoints list from `.gitlab/merge_request_templates/default.md`.
- CI must be green before merging: `.gitlab-ci.yml` on git.drupalcode.org validates `composer.json` and lints
  every YAML file.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- Never store a token in configuration. The `milvus_api_key` Key reads it from the `MILVUS_API_KEY` environment
  variable, and a server that differs per environment is set in `settings.php` from environment variables.
- Keep `ddev/docker-compose.milvus.yaml` and `tests/ci/docker-compose.milvus.yml` on the same image and setup. The
  DDEV Milvus has authorization off, so it never publishes a host port.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment
  (`1.0.0`) and are never moved once pushed.
