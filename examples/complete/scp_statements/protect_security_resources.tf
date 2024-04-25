data "aws_iam_policy_document" "protect_security_resources" {
  statement {
    sid    = "ProtectSecurityResources"
    effect = "Deny"
    resources = [
      "*"
    ]

    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:PutEventSelectors",
      "cloudtrail:StopLogging",
      "securityhub:DisassociateFromMasterAccount",
      "securityhub:DisableSecurityHub",
      "guardduty:Delete*",
      "guardduty:Disassociate*",
      "guardduty:Stop*",
      "guardduty:Update*",
      "config:DeleteConfigurationAggregator",
      "config:PutConfigurationAggregator",
    ]
  }
  statement {
    sid       = "ProtectEbsEncryptionByDefault"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["ec2:DisableEbsEncryptionByDefault"]
  }
}
