# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-vdb-milvus-provider.feature` | The webmaster saves the Milvus connection without an error; the Milvus API key is kept with the site's keys |
| `01-02-ai-vdb-milvus-access.feature` | Only the webmaster sees the Milvus settings |
| `01-03-ai-vdb-milvus-accessibility.feature` | The Milvus provider page keeps the label, link name and ARIA rules |

## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

CI applies Drupal CMS AI before the recipe. It sets up an amazee.ai trial as the default provider, so no key
is needed. CI runs Milvus 2.6 standalone as a CI service.
