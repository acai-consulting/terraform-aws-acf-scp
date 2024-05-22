# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  workload_units = [
    {
      name = "CICD"
    },
    {
      name = "Prod"
    },
    {
      name = "NonProd"
    }
  ]
  organizational_units = {
    level1_units : [
      # Sample "real-life" Org Structure
      {
        name = "SCP_CoreAccounts",
        level2_units = [
          {
            name = "Management"
          },
          {
            name = "Security"
          },
          {
            name = "Connectivity"
          }
        ]
      },
      {
        name = "SCP_SandboxAccounts",
      },
      {
        name = "SCP_WorkloadAccounts",
        level2_units = [
          {
            name         = "BusinessUnit_1"
            level3_units = local.workload_units
          },
          {
            name         = "BusinessUnit_2"
            level3_units = local.workload_units
          },
          {
            name         = "BusinessUnit_3"
            level3_units = local.workload_units
          }
        ]
      }
    ]
  }
}

module "ou_structure" {
  #checkov:skip=CKV_TF_1
  source               = "git::https://github.com/acai-consulting/terraform-aws-acf-org-ou-mgmt?ref=1.1.1"
  organizational_units = local.organizational_units
  providers = {
    aws = aws.org_mgmt
  }
}