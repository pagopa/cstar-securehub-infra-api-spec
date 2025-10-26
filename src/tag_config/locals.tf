locals {
  cwd_split = split("/", path.cwd)
  src_idx   = try(index(local.cwd_split, "src"), -1)
  relative_folder = local.src_idx == -1 ? "" : join(
    "/",
    slice(local.cwd_split, local.src_idx + 1, length(local.cwd_split))
  )
  folder_value = local.relative_folder != "" ? local.relative_folder : local.cwd_split[length(local.cwd_split) - 1]
  source_suffix = local.relative_folder != "" ? "/src/${local.relative_folder}" : ""
  tags = {
    CreatedBy   = "Terraform"
    Environment = title(var.environment)
    Owner       = "CSTAR"
    Source      = "https://github.com/pagopa/cstar-securehub-infra/tree/main${local.source_suffix}"
    # isolates the module working folder, removing the absolute path leading to the cwd and the leading slash
    Folder     = local.folder_value
    CostCenter = "TS310 - PAGAMENTI & SERVIZI"
    domain     = var.domain
  }
}
