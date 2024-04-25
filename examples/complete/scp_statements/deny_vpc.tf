data "aws_iam_policy_document" "deny_vpc" {
  statement {
    sid       = "DenyVpc"
    effect    = "Deny"
    resources = ["*"]
    # not comprehensive, only for demo purposes
    actions = [
      "ec2:CreateVpc",
      "ec2:ModifyVpc",
      "ec2:DeleteVpc",
    ]
  }
}
