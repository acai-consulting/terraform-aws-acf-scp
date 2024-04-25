import unittest
from unittest.mock import patch
from moto import mock_organizations
import my_module  # Assuming your function is saved in 'my_module.py'

class TestGetOUs(unittest.TestCase):
    @mock_organizations
    def setUp(self):
        """Setup for test case."""
        self.client = boto3.client('organizations', region_name='us-east-1')
        # Create a root and some organizational units for testing
        self.root_id = self.client.create_organization(FeatureSet='ALL')['Organization']['Roots'][0]['Id']
        self.ou_id = self.client.create_organizational_unit(ParentId=self.root_id, Name='BusinessUnit_1')['OrganizationalUnit']['Id']

    @patch('my_module.BOTO3_CLIENT')
    def test_get_ous(self, mock_client):
        """Test the get_ous function."""
        # Setup the mock
        mock_client.get_paginator.return_value.paginate.return_value = [{
            'OrganizationalUnits': [
                {'Id': self.ou_id, 'Name': 'BusinessUnit_1'}
            ]
        }]

        # Call the function with mocked data
        result = my_module.get_ous(self.root_id, '/BusinessUnit_1')

        # Assert expected outcome
        expected = [{'id': self.ou_id, 'name': 'BusinessUnit_1', 'path': '/root/BusinessUnit_1'}]
        self.assertEqual(result, expected)

if __name__ == '__main__':
    unittest.main()
