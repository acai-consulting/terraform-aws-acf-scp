locals {
  load={
    "result": {
        "r-s2bx": {
            "path": "/root"
            "scps": [
                "top_level"
            ]
        },
        "ou-s2bx-xcigt1e9": {
            "path": "/root/SCP_CoreAccounts",
            "scps": [
                "core_accounts"
            ]
        },
        "ou-s2bx-xittvp0u": {
            "path": "/root/SCP_CoreAccounts/Management",
            "scps": [
                "deny_vpc"
            ]
        },
        "ou-s2bx-i04l6y3r": {
            "path": "/root/SCP_SandboxAccounts",
            "scps": []
        },
        "ou-s2bx-mlmncp13": {
            "path": "/root/SCP_WorkloadAccounts",
            "scps": [
                "workload"
            ]
        },
        "ou-s2bx-ohnn8ba7": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_1",
            "scps": [
                "workload_class1"
            ]
        },
        "ou-s2bx-xadnwt8n": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_2",
            "scps": [
                "workload_class1",
                "workload_class3"
            ]
        },
        "ou-s2bx-0fospvae": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_3",
            "scps": [
                "workload_class2"
            ]
        },
        "ou-s2bx-ovi7tkhr": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_3/NonProd",
            "scps": [
                "workload_prod"
            ]
        },
        "ou-s2bx-oop793xt": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_2/NonProd",
            "scps": [
                "workload_prod"
            ]
        },
        "ou-s2bx-zf6m8x5g": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_1/NonProd",
            "scps": [
                "workload_prod"
            ]
        },
        "ou-s2bx-cn98fup1": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_3/Prod",
            "scps": [
                "workload_non_prod"
            ]
        },
        "ou-s2bx-9tb4zcv6": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_2/Prod",
            "scps": [
                "workload_non_prod"
            ]
        },
        "ou-s2bx-vdcv07wh": {
            "path": "/root/SCP_WorkloadAccounts/BusinessUnit_1/Prod",
            "scps": [
                "workload_non_prod"
            ]
        }
    }
}
}

output test {
    value = flatten([
    for ou_id, ou_info in local.load.result : [
      for scp_name in ou_info.scps : {
        ou_id    = ou_id,
        scp_name = scp_name
      }
    ]
  ])
}

output "ou_scp_mapping" {
  value = merge([
    for ou_id, ou_info in local.load.result : {
      for scp_name in ou_info.scps : "${ou_id}-${scp_name}" => {
        "ou_id"    = ou_id,
        "scp_name" = scp_name
      }
    }
  ]...)
}
