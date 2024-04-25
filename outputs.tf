output "ou_root_id" {
  value = local.root_ou_id
}

output "ou_paths_with_id" {
  value = local.ou_paths_with_id
}

output "scp_policies_details" {
  value =  {
    for key, policy in aws_organizations_policy.scp_policies : key => {
      name          = policy.name
      scp_id        = policy.id
      policy_length = length(policy.content)
    }
  }
}
