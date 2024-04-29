import json
import sys
import boto3


def _assume_remote_role(remote_role_arn):
    try:
        # Assumes the provided role in the auditing member account and returns a session
        # Beginning the assume role process for account
        sts_client = boto3.client('sts')

        response = sts_client.assume_role(
            RoleArn=remote_role_arn,
            RoleSessionName='RemoteSession'
        )

        # Storing STS credentials
        session = boto3.Session(
            aws_access_key_id=response["Credentials"]["AccessKeyId"],
            aws_secret_access_key=response["Credentials"]["SecretAccessKey"],
            aws_session_token=response["Credentials"]["SessionToken"]
        )
        return session

    except Exception as e:
        print(f'Was not able to assume role {remote_role_arn}')
        print(e)
        return None

def _get_ous(boto3_client, parent_ou_id, remaining_ou_path, recent_ou_path = "/root"):
    def get_ous_for_criteria(parent_id, criteria):
        found_ous = []
        paginator = boto3_client.get_paginator('list_organizational_units_for_parent')
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
            results.extend(_get_ous(boto3_client, result['id'], rest_of_path, f"{recent_ou_path}/{result['name']}" ))
    else:
        results.extend(found_ous)
    return results






external_root_ou_id = sys.argv[1] 
ou_assignments = json.loads(sys.argv[2])

# org_mgmt_role_arn provided?
if len(sys.argv) > 2:  
    session = _assume_remote_role(sys.argv[3])
    boto3_client = session.client('organizations')

else:
    boto3_client = boto3.client('organizations')

root_ou_id = boto3_client.list_roots()['Roots'][0]['Id']  # Assume single root
if external_root_ou_id != root_ou_id:
    raise(Exception(f"Not in the correct AWS Org. Required: {external_root_ou_id} Found: {root_ou_id}"))

ou_results = {}
for path, scps in ou_assignments.items():
    if path == '/root':
        ou_results[root_ou_id] = {'path':'/root', 'scps': scps}
    else:
        path = path.replace("/root", "", 1)
        ous = _get_ous(boto3_client, root_ou_id, path)

        for ou in ous:
            if ou['id'] in ou_results:
                ou_results[ou['id']]['scps'].append(scps)
            else:
                ou_results[ou['id']] = {"path": ou['path'], "scps": scps}

print(json.dumps({"result": json.dumps(ou_results)}))

