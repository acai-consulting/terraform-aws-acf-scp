# terraform-aws-acf-scp Terraform module

<!-- LOGO -->
<a href="https://acai.gmbh">    
  <img src="https://github.com/acai-consulting/acai.public/raw/main/logo/logo_github_readme.png" alt="acai logo" title="ACAI" align="right" height="75" />
</a>

<!-- SHIELDS -->
[![Maintained by acai.gmbh][acai-shield]][acai-url]
![module-version-shield]
![terraform-version-shield]
![trivy-shield]
![checkov-shield]
[![Latest Release][release-shield]][release-url]

<!-- DESCRIPTION -->
[Terraform][terraform-url] module to deploy provision and assign Service Control Policies (SCPs).


<!-- FEATURES -->
## Features
Will provision SCPs based on specified statements.

For the following demo OU-Structure:
/root
/root/SCP_CoreAccounts
/root/SCP_CoreAccounts/Connectivity
/root/SCP_CoreAccounts/Management
/root/SCP_CoreAccounts/Security
/root/SCP_SandboxAccounts
/root/SCP_WorkloadAccounts
/root/SCP_WorkloadAccounts/BusinessUnit_1
/root/SCP_WorkloadAccounts/BusinessUnit_1/CICD
/root/SCP_WorkloadAccounts/BusinessUnit_1/NonProd
/root/SCP_WorkloadAccounts/BusinessUnit_1/Prod
/root/SCP_WorkloadAccounts/BusinessUnit_2
/root/SCP_WorkloadAccounts/BusinessUnit_2/CICD
/root/SCP_WorkloadAccounts/BusinessUnit_2/NonProd
/root/SCP_WorkloadAccounts/BusinessUnit_2/Prod
/root/SCP_WorkloadAccounts/BusinessUnit_3
/root/SCP_WorkloadAccounts/BusinessUnit_3/CICD
/root/SCP_WorkloadAccounts/BusinessUnit_3/NonProd
/root/SCP_WorkloadAccounts/BusinessUnit_3/Prod

```hcl
locals {
  scp_specifications = {
    "top_level" = {
      policy_name = "top_level"
      statement_ids = [
        "deny_root_user"
      ]
    }
    "core_accounts" = {
      policy_name = "core_accounts"
      statement_ids = [
        "deny_iam_users"
      ]
    }
    "core_account_non_connectivity" = {
      policy_name = "core_account_non_connectivity"
      statement_ids = [
        "deny_vpc"
      ]
    }
    "workload" = {
      policy_name = "workload"
      statement_ids = [
        "deny_vpc",
        "protect_security_resources",
      ]
    }
    "workload_class1" = {
      policy_name = "workload_class1"
      statement_ids = [
        "allow_services1",
      ]
    }
    "workload_class2" = {
      policy_name = "workload_class2"
      statement_ids = [
        "allow_services2",
      ]
    }
    "workload_prod" = {
      policy_name = "workload_prod"
      statement_ids = [
        "deny_regions_prod",
        "deny_iam_users",
      ]
    }
    "workload_non_prod" = {
      policy_name = "workload_non_prod"
      statement_ids = [
        "deny_regions_nonprod",
      ]
    }
    "deny_vpc" = {
      policy_name = "deny_vpc"
      statement_ids = [
        "deny_vpc",
      ]
    }
  }

  scp_assignments = {
    ou_assignments = {
      "/root"                                     = ["top_level"]
      "/root/SCP_CoreAccounts"                    = ["core_accounts"]
      "/root/SCP_CoreAccounts/Management"         = ["deny_vpc"]
      "/root/SCP_SandboxAccounts"                 = []
      "/root/SCP_WorkloadAccounts"                = ["workload"]
      "/root/SCP_WorkloadAccounts/BusinessUnit_1" = ["workload_class1"]
      "/root/SCP_WorkloadAccounts/BusinessUnit_2" = ["workload_class1"]
      "/root/SCP_WorkloadAccounts/BusinessUnit_3" = ["workload_class2"]
      "/root/SCP_WorkloadAccounts/*/Prod"         = ["workload_prod"]
      "/root/SCP_WorkloadAccounts/*/NonProd"      = ["workload_non_prod"]
    }
    account_assignments = {
      "590183833356" = ["deny_vpc"] # core_logging
    }
  }
}

module "scp_statements" {
  source = "./scp_statements"
}

module "scp_management" {
  source = "../../"

  scp_statements     = module.scp_statements.scp_statements
  scp_specifications = local.scp_specifications
  scp_assignments    = local.scp_assignments
  providers = {
    aws = aws.org_mgmt_euc1
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.scp_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_account_assignment.scp_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_customer_managed_policy_attachment.scp_ps_customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment) | resource |
| [aws_ssoadmin_managed_policy_attachment.scp_ps_aws_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.scp_ps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.scp_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.scp_boundary_aws_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.scp_boundary_customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_identitystore_group.scp_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.scp_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_instances.scp_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_assignments"></a> [account\_assignments](#input\_account\_assignments) | A list of account assignments. | <pre>list(object({<br>    account_id = string,<br>    permissions = list(object({<br>      permission_set_name = string<br>      users               = optional(list(string), [])<br>      groups              = optional(list(string), [])<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | A list of AWS Identity Center Permission Sets. | <pre>list(object({<br>    name                      = string<br>    description               = optional(string, "not provided")<br>    session_duration_in_hours = optional(number, 4)<br>    relay_state               = optional(string, null)<br>    managed_policies = optional(list(object({<br>      managed_by  = string<br>      policy_name = string<br>      policy_path = optional(string, "/")<br>    })), [])<br>    inline_policy_json = optional(string, "")<br>    boundary_policies = optional(list(object({<br>      managed_by  = string<br>      policy_name = string<br>      policy_path = optional(string, "/")<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of tags to assign to the resources in this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_assignments"></a> [group\_assignments](#output\_group\_assignments) | Map of group assignments with Single Sign-On. |
| <a name="output_identity_store_arn"></a> [identity\_store\_arn](#output\_identity\_store\_arn) | The Amazon Resource Name (ARN) of the SSO Instance. |
| <a name="output_identity_store_id"></a> [identity\_store\_id](#output\_identity\_store\_id) | Identity Store ID associated with the Single Sign-On Instance. |
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | Map of permission sets configured to be used with Single Sign-On. |
| <a name="output_user_assignments"></a> [user\_assignments](#output\_user\_assignments) | Map of user assignments with Single Sign-On. |
<!-- END_TF_DOCS -->

<!-- AUTHORS -->
## Authors

This module is maintained by [ACAI GmbH][acai-url].

<!-- LICENSE -->
## License

See [LICENSE][license-url] for full details.

<!-- COPYRIGHT -->
<br />
<br />
<p align="center">Copyright &copy; 2024 ACAI GmbH</p>

<!-- MARKDOWN LINKS & IMAGES -->
[acai-url]: https://acai.gmbh
[acai-shield]: https://img.shields.io/badge/maintained_by-acai.gmbh-CB224B?style=flat
[module-version-shield]: https://img.shields.io/badge/module_version-1.1.1-CB224B?style=flat
[terraform-version-shield]: https://img.shields.io/badge/tf-%3E%3D1.3.10-blue.svg?style=flat&color=blueviolet
[trivy-shield]: https://img.shields.io/badge/trivy-passed-green
[checkov-shield]: https://img.shields.io/badge/checkov-passed-green
[release-shield]: https://img.shields.io/github/v/release/acai-consulting/terraform-aws-acf-scp?style=flat&color=success
[release-url]: https://github.com/acai-consulting/terraform-aws-acf-scp/releases
[license-url]: https://github.com/acai-consulting/terraform-aws-acf-scp/tree/main/LICENSE.md
[terraform-url]: https://www.terraform.io
