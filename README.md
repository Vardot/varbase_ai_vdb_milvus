[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI VDB: Milvus
[![CI](https://github.com/Vardot/varbase_ai_vdb_milvus/actions/workflows/ci.yml/badge.svg?branch=1.0.x)](https://github.com/Vardot/varbase_ai_vdb_milvus/actions/workflows/ci.yml)
[![Varbase AI VDB: Milvus](https://img.shields.io/badge/Varbase%20AI%20VDB%3A%20Milvus-1.0.2-0d6efc?labelColor=001d38&style=flat-square)](https://github.com/Vardot/varbase_ai_vdb_milvus/releases/tag/1.0.2)

A private Drupal recipe that connects a Varbase 11 site to a [Milvus](https://milvus.io) vector database for AI
Search. Milvus can run **locally inside the same DDEV project**, or **remotely** on Zilliz Cloud or on a server of
your own. The recipe is the same for all three. Only three values change.

It is one of three interchangeable vector database recipes for [Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base).
The others are [MariaDB](https://github.com/Vardot/varbase_ai_vdb_mariadb) and [SQLite](https://github.com/Vardot/varbase_ai_vdb_sqlite).

**Experimental.** The Milvus VDB provider (`drupal/ai_vdb_provider_milvus`) has no stable release, so this stack is
not covered by the Drupal security advisory policy.

There is **no custom PHP and no custom shell code** in the recipe. Its no-key checks run inline in CI, so the repository holds no PHP file at
all.

## What it adds

| Where | Change |
|---|---|
| Modules | Installs `key`, `ai`, `ai_search` and `ai_vdb_provider_milvus`. |
| Key | Creates `milvus_api_key`, which reads `MILVUS_API_KEY`. |
| Provider settings | Sets `ai_vdb_provider_milvus.settings` to the server, port and Key from the inputs. |

The recipe has three inputs:

| Input | Default | What it is |
|---|---|---|
| `server` | `MILVUS_SERVER` from the environment, otherwise `http://milvus` | The address, with the scheme and without the port. |
| `port` | `MILVUS_PORT` from the environment, otherwise `19530` | The REST port. Zilliz Cloud uses `443`. |
| `api_key` | empty | The id of the Key that holds the token. Empty means no token. |

It does **not** create a Search API server or index. That needs an embeddings model and belongs to
[Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base).

## Requirements

- Drupal core `^11.4`, Varbase 11
- [`drupal/ai`](https://www.drupal.org/project/ai) `^1.4`
- [`drupal/ai_vdb_provider_milvus`](https://www.drupal.org/project/ai_vdb_provider_milvus) `^1.1@beta`, no stable
  release (1.1.0-beta4 tested)
- [`drupal/key`](https://www.drupal.org/project/key) `^1.18`
- [`drupal/search_api`](https://www.drupal.org/project/search_api) `^1.40`, which AI Search needs
- A Milvus 2.6 server: the DDEV service in `ddev/`, Zilliz Cloud, or one of your own

## Install and apply

Locally, inside the same DDEV project:

```bash
# 1. Fetch the recipe. The repository is private, so Composer clones it over SSH.
ddev auth ssh
ddev composer config repositories.varbase_ai_vdb_milvus vcs git@github.com:Vardot/varbase_ai_vdb_milvus.git
ddev composer config --json extra.drupal-recipe-unpack.ignore '["vardot/varbase_ai_vdb_milvus"]'
ddev composer require vardot/varbase_ai_vdb_milvus:~1.0.2 --prefer-source

# 2. Add Milvus to DDEV: one container, Milvus standalone with embedded etcd and local storage, no host port.
cp recipes/varbase_ai_vdb_milvus/ddev/docker-compose.milvus.yaml .ddev/
ddev restart

# 3. Apply it. Rebuild caches before and after: Drupal does not see the new modules or their plugins until it does.
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_vdb_milvus
ddev drush cr

# 4. Make it the site's default vector database, which Varbase AI Search reads.
ddev drush cset ai.settings default_vdb_provider milvus -y

# 5. Check it against the live Milvus. No AI key is needed.
ddev drush php:eval "$(sed -n "/<<'PHP'/,/^ *PHP\$/p" recipes/varbase_ai_vdb_milvus/.github/workflows/ci.yml | sed '1d;$d')"
```

Use `1.0.x-dev` instead of `~1.0.2` to follow the development branch. The ignore line keeps the recipe a locked
package: without it core's recipe-unpack plugin moves its requirements into the project's `composer.json` and
drops the recipe itself. Re-applying the recipe is safe.

The recipe points the provider at `http://milvus` on port `19530`, the DDEV service, with no token. That Milvus has
authorization switched off, so keep the container on the project's private DDEV network and never publish its
ports.

### The DDEV Milvus is now one container

`ddev/docker-compose.milvus.yaml` runs Milvus 2.6 standalone with embedded etcd and local storage
(`ETCD_USE_EMBED`, `COMMON_STORAGETYPE=local`). It is the same setup as Milvus's own `standalone_embed.sh`.

It used to be three containers: Milvus, etcd and MinIO. The `minio/minio` image can no longer be pulled from Docker
Hub or quay.io, so that setup could not start on a new machine.

- An existing DDEV project with the old file keeps working on its cached images.
- A project that switches to the new file starts with an **empty Milvus**. Create the `varbase_ai_search` database
  again (see [Use it with Varbase AI Search](#use-it-with-varbase-ai-search)), then re-index the content from
  Varbase AI Search.

## Use it with Varbase AI Search

Varbase AI Search names its vector database `varbase_ai_search`. A collection can only be made in a Milvus database
that exists, so create it first. In DDEV:

```bash
# If the call is refused, wait for the milvus container to be healthy and run it again.
ddev exec 'curl -s http://milvus:19530/v2/vectordb/databases/create -X POST -H "Content-Type: application/json" -d "{\"dbName\":\"varbase_ai_search\"}"'
```

On a remote server, call `<server>:<port>/v2/vectordb/databases/create` the same way, and add
`-H "Authorization: Bearer $MILVUS_API_KEY"` on a server with authorization.

## Where Milvus runs

| | Local: DDEV | Remote: Zilliz Cloud | Remote: your own server |
|---|---|---|---|
| Who runs Milvus | DDEV, one container | Zilliz | You |
| `MILVUS_SERVER` | `http://milvus` (the default) | `https://<cluster>.zillizcloud.com` | `https://milvus.example.com` |
| `MILVUS_PORT` | `19530` (the default) | `443` | `19530`, or `443` behind TLS |
| `MILVUS_API_KEY` | not set | the Zilliz API token | `root:<password>` |
| `api_key` input | empty (the default) | `milvus_api_key` | `milvus_api_key` |
| Tested | Yes, and in CI | Mechanism only | Yes with authorization on, on the DDEV network |

### Remote

Both remote setups use the same steps: set three environment variables, apply the recipe with the token input,
check it.

```bash
# The address and token are never stored in configuration. Set them in the environment of the web
# container (in DDEV, web_environment in .ddev/config.local.yaml) or of the server.
#   MILVUS_SERVER   the address with the scheme and without the port
#   MILVUS_PORT     the REST port
#   MILVUS_API_KEY  the token

ddev composer require vardot/varbase_ai_vdb_milvus:~1.0.2 --prefer-source   # as above
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_vdb_milvus --input=varbase_ai_vdb_milvus.api_key=milvus_api_key
ddev drush cr
ddev drush php:eval "$(sed -n "/<<'PHP'/,/^ *PHP\$/p" recipes/varbase_ai_vdb_milvus/.github/workflows/ci.yml | sed '1d;$d')"
```

Each input can also be passed directly, for example `--input=varbase_ai_vdb_milvus.server=https://...`.

The recipe check creates and drops a throw-away collection called `vdb_verify_milvus` on the server it connects to.
Run it against a database where that is acceptable.

**Do not pass `api_key=milvus_api_key` while `MILVUS_API_KEY` is unset.** The Key then returns `NULL`, and the
provider fails with `TypeError: setApiKey(): Argument #1 must be of type string, null given`. An empty `api_key`,
which is the default, skips the Key and is right only for a Milvus without authorization.

### Zilliz Cloud

1. Create a cluster and copy its public endpoint and API token from the Zilliz console.
2. Set `MILVUS_SERVER` to the endpoint with `https://`, `MILVUS_PORT` to `443`, and `MILVUS_API_KEY` to the token.
3. Apply and check as above.

Zilliz Cloud serverless has no database name to choose: the provider's own form says to enter anything, such as
`default`, and ignores it. The provider documents Zilliz Cloud support, but it was **not tried against a real
Zilliz cluster**.

### Your own server

1. Run Milvus standalone on a host you control. `ddev/docker-compose.milvus.yaml` is a working starting point.
   Change two things before it faces anything else: set `COMMON_SECURITY_AUTHORIZATIONENABLED` to `"true"`, and
   change the default `root` password (`Milvus`).
2. Publish nothing but the REST port. Put Milvus behind a TLS reverse proxy and allow only the site's addresses.
3. Set `MILVUS_SERVER` (`https://milvus.example.com`), `MILVUS_PORT` (`443` behind TLS, otherwise `19530`) and
   `MILVUS_API_KEY` (`root:<password>`). Apply and check as above.

Tested on 5 October 2026 with authorization switched on in the DDEV Milvus, then the three-container setup: with no
token the provider is refused (`401 Unauthorized`), with a wrong token it is refused, and with `root:Milvus` the full
test passes. The TLS reverse proxy and a Milvus on another host were **not tested**.

### One project, different Milvus per environment

The recipe stores the server and port in configuration, and configuration is exported and imported between
environments. A project that uses the DDEV Milvus locally and a remote one on Upsun should read them from the
environment in `settings.php` instead, which takes precedence over stored configuration:

```php
$config['ai_vdb_provider_milvus.settings']['server'] = getenv('MILVUS_SERVER') ?: 'http://milvus';
$config['ai_vdb_provider_milvus.settings']['port'] = (int) (getenv('MILVUS_PORT') ?: 19530);
// Only point the provider at the Key when there is a token: an unset variable crashes it (see above).
$config['ai_vdb_provider_milvus.settings']['api_key'] = getenv('MILVUS_API_KEY') ? 'milvus_api_key' : '';
```

A recipe cannot write `settings.php`. Tested: an override of the server to an unreachable host made the test fail
although the stored server was correct, and an override back to the working server passed.

### On Upsun

Upsun has no Milvus service, so on Upsun the server is always remote. Set the three variables on the Upsun
environment, keep them out of the repository, and use the `settings.php` override above so that the same code
works locally and there. **Not tested on Upsun.**

## Automated testing

`.github/workflows/ci.yml` runs on every pull request, every push to `1.0.x` and every tag:

1. **Lint**: `composer validate`, every YAML file, and PHP syntax.
2. **Apply on Drupal 11.4 with Milvus 2.6**: Milvus 2.6.21 starts from `tests/ci/docker-compose.milvus.yml`, the
   same single container as `ddev/`, with its ports published on the runner. A fresh `drupal/recommended-project`
   site requires this checkout, applies the recipe with the `server` and `port` inputs read from `MILVUS_SERVER`
   and `MILVUS_PORT` in the environment, applies it again, and runs the no-key recipe check.
3. **Functional tests**: the same job then serves the site and runs the Playwright + Cucumber scenarios in
   `tests/features` through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e) in
   Chromium. The Webmaster provisions the testing users first, then the scenarios check the admin pages the
   recipe adds, every page for PHP errors, and that a visitor without the permission is kept out. Screenshots
   and reports of a failed run are kept as the `functional-tests` artifact. To run them against a site of
   your own: `yarn install`, then `LAUNCH_URL=https://your-site.ddev.site yarn test`.

The CI step "Check the recipe without an AI key" (an inline `drush php:eval` in `.github/workflows/ci.yml`) needs no AI key. It pings the provider, creates a collection, inserts three vectors, checks that
a search ranks them in the right order, and drops the collection. It creates and drops a throw-away collection
called `vdb_verify_milvus` in the database it connects to. The Search API server and index that the search needs
are built in memory, so the test runs on any Drupal site and saves nothing to it.

## Checked

In CI on every change, as above. By hand on 5 October 2026, against the `Vardot/platformsh-varbase` template
(Drupal 11.4.5, `drupal/ai` 1.4.7, PHP 8.4, MariaDB 11.8), with `ai_vdb_provider_milvus` 1.1.0-beta4 and
Milvus 2.6.21 in DDEV, then the three-container setup:

- The recipe applies, applies again, and stores the expected settings (`port` as an integer).
- The recipe check passes: ping, create a collection, insert three vectors, search ranks them in the right order,
  drop the collection. It leaves nothing behind.
- The token path works with authorization switched on (refused without a token and with a wrong one, accepted with
  the right one).
- The `settings.php`-style override takes precedence over stored configuration.

**Not checked:** a real Zilliz Cloud cluster, a Milvus on another host or behind TLS, anything on an Upsun
environment, and indexing real content, which needs an embeddings provider key. The tests above ran with the
`ai_search` bundled in `drupal/ai`, not the standalone `ai_search` 1.3 that Varbase AI Search brings. The
[Varbase AI Chatbot Base](https://github.com/Vardot/varbase_ai_chatbot_base) README records one site where this
recipe and Varbase AI Search ran together, on 8 October 2026.

## Known issues in the provider

- A Key whose value is `NULL` crashes the provider (above).
- `getCollections()` returns Milvus's raw answer, `{code: 0, data: [names]}`, although the interface documents a
  list of names. The recipe check accepts both.
- `dropCollection()` ignores its database argument and always drops from the default database. In any other
  Milvus database a dropped collection stays, and clearing a Search API index (drop, then create) is likely to
  leave the old vectors. Found because the recipe check run against a named database against a non-default database
  fails at the drop and leaves its throw-away collection behind.
- A collection can only be made in a Milvus database that exists. Varbase AI Search uses `varbase_ai_search`, so
  create it first (see [Use it with Varbase AI Search](#use-it-with-varbase-ai-search)).
- The 2.0.x line of the provider needs `drupal/ai ^2.0`. This recipe targets 1.1.x with `drupal/ai ^1.4`.

## Related recipes

| Recipe | What it does |
|---|---|
| [Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base) | The vector index of the site's content, on the default vector database. |
| [Varbase AI Answers](https://github.com/Vardot/varbase_ai_answers_base) | Ask AI: cited answers over that index. |
| [Varbase AI Chatbot Base](https://github.com/Vardot/varbase_ai_chatbot_base) | A visitor chatbot over that index. |
| [Varbase AI VDB: MariaDB](https://github.com/Vardot/varbase_ai_vdb_mariadb) | MariaDB's native `VECTOR` type as the vector database. |
| [Varbase AI VDB: SQLite](https://github.com/Vardot/varbase_ai_vdb_sqlite) | SQLite with sqlite-vec as the vector database. |

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
