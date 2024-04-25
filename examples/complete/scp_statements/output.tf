output "scp_statements" {
  value = {
    "allow_services1"            = data.aws_iam_policy_document.allow_services1
    "allow_services2"            = data.aws_iam_policy_document.allow_services2
    "deny_iam_users"             = data.aws_iam_policy_document.deny_iam_users
    "deny_public_lambda"         = data.aws_iam_policy_document.deny_public_lambda
    "deny_regions_prod"          = data.aws_iam_policy_document.deny_regions_prod
    "deny_regions_nonprod"       = data.aws_iam_policy_document.deny_regions_nonprod
    "deny_root_user"             = data.aws_iam_policy_document.deny_root_user
    "deny_s3_public_access"      = data.aws_iam_policy_document.deny_s3_public_access
    "deny_vpc"                   = data.aws_iam_policy_document.deny_vpc
    "protect_security_resources" = data.aws_iam_policy_document.protect_security_resources
  }
}
