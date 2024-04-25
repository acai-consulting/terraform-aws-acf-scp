data "aws_iam_policy_document" "deny_s3_public_access" {
  statement {
    sid       = "S3BlockPublicAccess"
    effect    = "Deny"
    resources = ["*"]
    actions = [
      "s3:PutAccountPublicAccessBlock",
      "s3:DeletePublicAccessBlock"
    ]
  }
}
