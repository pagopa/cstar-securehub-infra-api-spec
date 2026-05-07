# Copilot instructions

This repository manages Azure API Management (APIM) configuration plus external OpenAPI specifications for CSTAR SecureHub. Changes often span Terraform, OpenAPI, and APIM policy XML together.

## Build, test, and lint commands

- Full repo static checks used by CI: `pre-commit run --all-files`
- Terraform formatting only: `pre-commit run terraform_fmt --all-files`
- Terraform validation hook: `pre-commit run terraform_validate --all-files`
- Inspect available environments for one stack: `cd src/<domain> && ./terraform.sh list`
- Plan one Terraform stack: `cd src/<domain> && ./terraform.sh init <env> && ./terraform.sh plan <env>`  
  `terraform.sh` expects Azure CLI access plus `env/<env>/backend.tfvars` and `env/<env>/terraform.tfvars`.
- Lint one IDPay OpenAPI file with the same rules used in CI: `npm install -g @stoplight/spectral-cli && npm install @stoplight/spectral-owasp-ruleset && spectral lint -r .spectral.yaml src/idpay/apim/api/idpay_wallet/openapi.wallet.yml.tpl`
- Rebuild the merged AppIO spec checked in PRs: `npm i -g openapi-merge-cli && cd scripts/idpay-script && npx openapi-merge-cli`
- Check the merged AppIO output against the committed file: `diff -u src/idpay/apim/api/idpay_appio_full/openapi.appio.full.yml src/idpay/apim/api/idpay_appio_full/openapi.appio.full.merged.yml`

## High-level architecture

- `src/idpay`, `src/mcshared`, `src/mdc`, and `src/srtp` are separate Terraform roots. Each has its own `env/` directory and its own `terraform.sh`, so Terraform commands should run from the domain folder, not from the repo root.
- `idpay` is the outlier: APIs are declared explicitly in many `20_apim_api_*.tf` files using the shared PagoPA APIM modules from `terraform-azurerm-v4`. Each module imports an OpenAPI file from `src/idpay/apim/api/**`, attaches a product, applies `base_policy.xml`, and optionally wires per-operation XML policies inline. Diagnostics are added later in `src/idpay/30_apim_diagnostics.tf`.
- `mcshared`, `mdc`, and `srtp` are map-driven. Their `99_locals.tf` files define `apis`, `products`, `policy_fragment`, and `api_operation_policy`; the numbered Terraform files (`01/02_api.tf`, `02_product.tf`, `03_api_policy_fragment.tf`, `04_api_operation_policy.tf`, `05_api_policy.tf`, `06_api_diagnostics.tf`, `07_api_version_set.tf`, `08_group.tf`) materialize those maps with `for_each`.
- OpenAPI sources are part of the Terraform source of truth. Some are loaded with `file()`, others with `templatefile()`, so edits to YAML and `.tpl` files directly affect APIM imports.
- APIM XML is organized beside the specs: `idpay` uses `apim/api/**` plus `apim/api_product/**`; the map-driven stacks use `api/**`, `api_fragment/**`, and `api_product/**` or `policies/**`.
- `scripts/idpay-script/openapi-merge.json` merges several IDPay AppIO specs into `src/idpay/apim/api/idpay_appio_full/openapi.appio.full.merged.yml`. The PR workflow compares that merged output with the committed `openapi.appio.full.yml`, so AppIO edits may need the merge step as well as per-file linting.

## Key conventions

- Keep OpenAPI specs on version `3.0.3`. Existing files consistently follow the ordering `openapi`, `info`, `servers`, optional `security`/`tags`, `paths`, `components`.
- Keep local `$ref` values single-quoted, for example `$ref: '#/components/schemas/MySchema'`.
- In `mcshared`, `mdc`, and `srtp`, start changes in `99_locals.tf`. Optional keys such as `version_set`, `api_policy`, `api_diagnostic`, and `group` automatically enable more APIM resources through the generic Terraform files.
- Do not rename an OpenAPI `operationId` without updating the matching APIM policy wiring. `idpay` maps operation policies inside each module block; the other stacks map them through `local.api_operation_policy`.
- `base_policy.xml` files are intentionally thin and rely on `<base />`; most request routing, auth, and header manipulation lives in operation-specific XML templates or shared policy fragments.
- For IDPay AppIO files matched by `.spectral.yaml`, request integers must define both `minimum` and `maximum`, and request strings must define `maxLength`, `enum`, or `const` and should also provide `format`, `pattern`, `enum`, or `const`.
- When adding a new explicit IDPay API module, also update `src/idpay/30_apim_diagnostics.tf`; otherwise the API will be created without the shared Application Insights diagnostic settings.
- `mdc` APIs can attach to multiple products via `products = [...]`; `mcshared` and `srtp` use a single `product` key per API entry.
