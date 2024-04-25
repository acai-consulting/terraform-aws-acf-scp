import json
import sys
import boto3

BOTO3_CLIENT = boto3.client('organizations')
def get_ous(parent_ou_id, remaining_ou_path, recent_ou_path = "/root"):
    def get_ous_for_criteria(parent_id, criteria):
        found_ous = []
        paginator = BOTO3_CLIENT.get_paginator('list_organizational_units_for_parent')
        for page in paginator.paginate(ParentId=parent_id):
            for ou in page['OrganizationalUnits']:
                if ou['Name'] == criteria or criteria == "*":
                    found_ous.append(
                        {
                            'id': ou['Id'], 
                            'name': ou['Name'], 
                            'path': f'{recent_ou_path}/{ou["Name"]}'
                        }
                    )
        return found_ous

    results = []
    parts = remaining_ou_path.strip("/").split('/')    
    first_element = parts[0]
    found_ous = get_ous_for_criteria(parent_ou_id, first_element)
    if len(parts) > 1:
        rest_of_path = '/' + '/'.join(parts[1:])
        for result in found_ous:
            results.extend(get_ous(result['id'], rest_of_path, f"{recent_ou_path}/{result['name']}" ))
    else:
        results.extend(found_ous)
    return results

external_root_ou_id = sys.argv[1] 
ou_assignments = json.loads(sys.argv[2])
"""
external_root_ou_id = "r-s2bx"
ou_assignments = {
    "/root"                                     : ["top_level"],
    "/root/SCP_CoreAccounts"                    : ["core_accounts"],
    "/root/SCP_CoreAccounts/Management"         : ["deny_vpc"],
    "/root/SCP_SandboxAccounts"                 : [],
    "/root/SCP_WorkloadAccounts"                : ["workload"],
    "/root/SCP_WorkloadAccounts/BusinessUnit_1" : ["workload_class1"],
    "/root/SCP_WorkloadAccounts/BusinessUnit_2" : ["workload_class1"],
    "/root/SCP_WorkloadAccounts/BusinessUnit_3" : ["workload_class2"],
    "/root/SCP_WorkloadAccounts/*/NonProd"      : ["workload_prod"],
    "/root/SCP_WorkloadAccounts/*/Prod"         : ["workload_non_prod"]
}
"""

root_ou_id = BOTO3_CLIENT.list_roots()['Roots'][0]['Id']  # Assume single root
if external_root_ou_id != root_ou_id:
    raise(Exception(f"Not in the correct AWS Org. Required: {external_root_ou_id} Found: {root_ou_id}"))

ou_results = {}
for path, scps in ou_assignments.items():
    if path == '/root':
        ou_results[root_ou_id] = {'path':'/root', 'scps': scps}
    else:
        path = path.replace("/root", "", 1)
        ous = get_ous(root_ou_id, path)

        for ou in ous:
            if ou['id'] in ou_results:
                ou_results[ou['id']]['scps'].append(scps)
            else:
                ou_results[ou['id']] = {"path": ou['path'], "scps": scps}

print(json.dumps({"result": json.dumps(ou_results)}))
