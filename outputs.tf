output "ou_root_id" {
  value = local.root_ou_id
}

output "ou_paths_with_id" {
  value = local.ou_paths_with_id
}

output "scp_policies_details" {
  value = {
    for key, policy in aws_organizations_policy.scp_policies : key => {
      name          = policy.name
      arn           = policy.arn
      scp_id        = policy.id
      policy_length = length(policy.content)
    }
  }
}

output "aws_organizations_policy_ou_attachment" {
  value = aws_organizations_policy_attachment.ou_attachment
}

output "aws_organizations_policy_account_attachment" {
  value = aws_organizations_policy_attachment.account_attachment
}