output "scp_statements" {
  value = {
    "allow_services1"            = data.aws_iam_policy_document.allow_services1.json
    "allow_services2"            = data.aws_iam_policy_document.allow_services2.json
    "deny_iam_users"             = data.aws_iam_policy_document.deny_iam_users.json
    "deny_public_lambda"         = data.aws_iam_policy_document.deny_public_lambda.json
    "deny_regions_prod"          = data.aws_iam_policy_document.deny_regions_prod.json
    "deny_regions_nonprod"       = data.aws_iam_policy_document.deny_regions_nonprod.json
    "deny_root_user"             = data.aws_iam_policy_document.deny_root_user.json
    "deny_s3_public_access"      = data.aws_iam_policy_document.deny_s3_public_access.json
    "deny_vpc"                   = data.aws_iam_policy_document.deny_vpc.json
    "protect_security_resources" = data.aws_iam_policy_document.protect_security_resources.json
  }
}
