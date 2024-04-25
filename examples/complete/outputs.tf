output "account_id" {
  description = "AWS Account ID number of the account that owns or contains the calling entity."
  value       = data.aws_caller_identity.current.account_id
}

output "ou_structure_paths" {
  value = module.ou_structure.organizational_units_paths_ids
}

output "ou_structure_paths" {
  value = module.ou_structure.organizational_units_paths_ids
}


output "test_success_1" {
  value = true
}
