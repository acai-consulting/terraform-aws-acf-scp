
module "scp_statements" {
  source = "../scp_statements"
}


data "aws_iam_policy_document" "scp_policies" {
  for_each = var.scp_specifications

  source_policy_documents = [for sid in each.value.statement_ids : var.scp_statements[sid]]
}
