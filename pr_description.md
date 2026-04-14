# PR Description

### List of changes

- Added `404` response (empty body) to the `GET /activations/payer` (`findActivationByPayerId`) operation in `src/srtp/api/pagopa/activation.yaml`
- The `404` response is defined inline with `description: Not found.` and no response body, as the endpoint returns an empty response when the payer activation is not found
- Placed the `404` response in the correct order between `403` and `406`, consistent with the other endpoints in the same file

### Motivation and context

The `findActivationByPayerId` endpoint was missing the `404` response code in its OpenAPI specification. This response is needed to properly document the case where no activation is found for the given payer ID. Unlike other error responses in the spec (which return a JSON error body via `$ref: '#/components/responses/Error'`), this `404` returns an empty body.

### Type of changes

- [ ] Add new resources
- [x] Update configuration to existing resources
- [ ] Remove existing resources

### Env to apply

- [x] DEV
- [x] UAT
- [x] PROD

### Does this introduce a change to production resources with possible user impact?

- [ ] Yes, users may be impacted applying this change
- [x] No

### Does this introduce an unwanted change on infrastructure? Check terraform plan execution result

- [ ] Yes
- [x] No

### Other information

Only the OpenAPI spec file `src/srtp/api/pagopa/activation.yaml` has been modified. No Terraform resources or infrastructure changes are involved.

---

### If PR is partially applied, why? (reserved to mantainers)

N/A
