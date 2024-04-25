import json
import sys
import boto3

def list_ous(ou_path):
    """List all organizational units under a given path."""
    client = boto3.client('organizations')
    root_id = client.list_roots()['Roots'][0]['Id']  # Assume single root

    # Helper function to recursively list OUs
    def recursive_list_ous(parent_id, path_prefix):
        ous = []
        paginator = client.get_paginator('list_organizational_units_for_parent')
        for page in paginator.paginate(ParentId=parent_id):
            for ou in page['OrganizationalUnits']:
                full_path = f"{path_prefix}/{ou['Name']}"
                ous.append((full_path, ou['Id']))
                ous.extend(recursive_list_ous(ou['Id'], full_path))
        return ous

    # Start listing from the root
    return recursive_list_ous(root_id, ou_path)


input_text = sys.argv[1]
prefix = sys.argv[2] if len(sys.argv) > 2 else ''
ou_paths = json.loads(input_text)
ou_results = {}
for path in ou_paths:
    ous = list_ous(path)
    for ou, ou_id in ous:
        ou_results[ou] = ou_id
print(json.dumps({"result": json.dumps(ou_results)}))
