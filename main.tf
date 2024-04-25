# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.3.10"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.47"
      configuration_aliases = []
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
data "aws_organizations_organization" "organization" {}

data "aws_organizations_organizational_units" "organization_inits" {
  parent_id = data.aws_organizations_organization.organization.roots[0].id
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  root_ou_id = data.aws_organizations_organization.organization.roots[0].id
}


# ---------------------------------------------------------------------------------------------------------------------
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
data "external" "get_ou_ids" {
  program = ["python3", "${path.module}/python/get_ou_ids.py", local.root_ou_id, jsonencode(var.scp_assignments.ou_assignments)]
}

locals {
  ou_paths_with_id = jsondecode(data.external.get_ou_ids.result["result"])
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ RESOURCES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_organizations_policy" "scp_policies" {
  for_each = var.scp_specifications

  name        = each.value.policy_name
  description = each.value.description
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for sid in each.value.statement_ids : var.scp_statements[sid]
    ]
  })
  tags = merge(var.default_tags, each.value.tags)
}

# Attach to Organizational Units
resource "aws_organizations_policy_attachment" "ou_attachment" {
  for_each = tomap([
    for ou_id, ou_info in local.ou_paths_with_id : [
      for scp_name in ou_info.scps : { "${ou_id}-${scp_name}" : {
        ou_id    = ou_id,
        scp_name = scp_name
      } }
    ]
  ])

  policy_id = aws_organizations_policy.scp_policies[each.value.scp_name].id
  target_id = each.value.ou_id # OU ID is expected here
}

# Attach to Accounts
resource "aws_organizations_policy_attachment" "account_attachment" {
  for_each = tomap(flatten([
    for acct_id, scps in var.scp_assignments.account_assignments : [
      for scp_name in scps : { "${acct_id}-${scp_name}" : {
        acct_id  = acct_id,
        scp_name = scp_name
      } }
    ]
  ]))

  policy_id = aws_organizations_policy.scp_policies[each.value.scp_name].id
  target_id = each.value.acct_id # Account ID is expected here
}

