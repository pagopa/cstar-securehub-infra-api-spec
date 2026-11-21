# cstar-securehub-infra-api-spec

Repository for managing external OpenAPI specifications and related policies.

## Listmonk

Public newsletter routes are managed by `src/mcshared`, alongside Keycloak ITN.
The OpenAPI contract and API-specific policy are in `src/mcshared/apim/api/listmonk/`.
The API reuses the existing `mcshared` product and review/deploy pipelines.

Workload/database configuration and the deployment runbook remain in
`cstar-securehub-infra/docs/LISTMONK_AKS_DEPLOYMENT_ANALYSIS.md`; the gateway allowlist
belongs to `cstar-infrastructure` and certificate definitions to `cstar-platform-azure-devops`.
