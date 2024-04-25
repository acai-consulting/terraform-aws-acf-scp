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
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
data "external" "get_ou_ids" {
  program = ["python3", "${path.module}/python/get_ou_ids.py", jsonencode(var.scp_assignments.ou_assignments.keys)]
}

locals {
  ou_paths_with_id = jsondecode(data.external.get_ou_ids.result["result"])
}

/*
# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  root_ou_id                     = data.aws_organizations_organization.organization.roots[0].id
  organizational_units_paths_ids = { for ou in data.aws_organizations_organizational_units.example.children : ou.name => ou.id }
}

resource "aws_organizations_policy" "scp_policies" {
  for_each = var.scp_specifications

  name        = each.value.policy_name
  description = each.value.description
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for sid in each.value.statement_id : jsondecode(var.scp_statements[sid])
    ]
  })
  tags = merge(var.default_tags, each.value.tags)
}

# Attach to Organizational Units
resource "aws_organizations_policy_attachment" "ou_attachment" {
  for_each = { for ou, scps in var.scp_assignments.ou_assignments : ou => scps }
  
  policy_id     = aws_iam_policy.scp_policies[each.key].id
  target_id     = each.key   # OU ID is expected here
}

# Attach to Accounts
resource "aws_organizations_policy_attachment" "account_attachment" {
  for_each = { for acct, scps in var.scp_assignments.account_assignments : acct => scps }
  
  policy_id     = aws_iam_policy.scp_policies[each.key].id
  target_id     = each.key   # Account ID is expected here
}


output "scp_policies_details" {
  value = aws_iam_policy.scp_policies
}
*/