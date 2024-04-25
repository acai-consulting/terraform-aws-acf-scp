data "aws_iam_policy_document" "deny_public_lambda" {
  statement {
    sid    = "DenyPublicLambda"
    effect = "Deny"
    resources = [
      "*"
    ]
    actions = [
      "lambda:CreateFunctionUrlConfig"
    ]

    condition {
      test     = "StringEquals"
      variable = "lambda:FunctionUrlAuthType"

      values = [
        "NONE"
      ]
    }
  }  
}