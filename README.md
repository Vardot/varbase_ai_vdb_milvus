[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI VDB: Milvus
[![Varbase AI VDB: Milvus](https://img.shields.io/badge/Varbase%20AI%20VDB%3A%20Milvus-1.0.0--beta1-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_vdb_milvus)

A Drupal recipe that connects a Varbase 11 site to a [Milvus](https://milvus.io) vector database for AI
Search. Milvus can run **locally inside the same DDEV project**, or **remotely** on Zilliz Cloud or on a server of
your own. The recipe is the same for all three. Only three values change.

## Documentation

Read the [Varbase AI VDB: Milvus documentation](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-vdb-milvus) on the Varbase docs site.

## Install and apply

Locally, inside the same DDEV project:

```bash
# 1. Fetch the recipe.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_vdb_milvus"]'
ddev composer require drupal/varbase_ai_vdb_milvus:~1

# 2. Add Milvus to DDEV: one container, Milvus standalone with embedded etcd and local storage, no host port.
cp recipes/varbase_ai_vdb_milvus/ddev/docker-compose.milvus.yaml .ddev/
ddev restart

# 3. Apply it. Rebuild caches before and after: Drupal does not see the new modules or their plugins until it does.
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_vdb_milvus
ddev drush cr

# 4. Make it the site's default vector database, which Varbase AI Search reads.
ddev drush cset ai.settings default_vdb_provider milvus -y

```

The ignore line keeps the recipe a locked
package: without it core's recipe-unpack plugin moves its requirements into the project's `composer.json` and
drops the recipe itself. Re-applying the recipe is safe.

The recipe points the provider at `http://milvus` on port `19530`, the DDEV service, with no token. That Milvus has
authorization switched off, so keep the container on the project's private DDEV network and never publish its
ports.

## Automated testing

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_vdb_milvus) (`.gitlab-ci.yml`) builds
a Varbase 11 site, applies this recipe twice and runs the Varbase functional testing suite in `tests/` on it. See
[tests/README.md](tests/README.md) to run it against a site of your own.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
