variable "scp_statements" {
  description = "The statements of the SCPs."
  type        = map(string) # key: statement_id, value: statement-json
}

variable "scp_specifications" {
  description = "The statements of the SCPs."
  # key: scp_id, value: specified object 
  type = map(object({
    policy_name : string
    description : optional(string, null)
    statement_ids : list(string)
    tags : optional(map(string), {})
  }))
}

variable "scp_assignments" {
  description = "The assignements of SCPs."
  type = object({
    ou_assignments : optional(map(list(string)), {})      # key: ou-path, value: list of scp_ids to be assinged
    account_assignments : optional(map(list(string)), {}) # key: account_id, value: list of scp_ids to be assinged
  })
  default = null
}

variable "org_mgmt_role_arn" {
  description = "ARN to be assumed by the Python."
  type = string
  default = ""
}

variable "default_tags" {
  description = "A map of default tags to assign to the SCPs."
  type        = map(string)
  default     = {}
}
