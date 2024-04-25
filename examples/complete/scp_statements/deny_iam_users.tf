data "aws_iam_policy_document" "deny_iam_users" {
  statement {
    sid       = "DenyIamUsers"
    effect    = "Deny"
    resources = ["*"]

    actions = [
      "iam:CreateUser"
    ]
  }
}
