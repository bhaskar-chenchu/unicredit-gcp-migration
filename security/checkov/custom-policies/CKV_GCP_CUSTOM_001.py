"""
Custom Checkov Policy: Cloud SQL Must Use Private IP Only
Policy ID: CKV_GCP_CUSTOM_001
Severity: HIGH

UniCredit Security Requirement:
All Cloud SQL instances must use private IP addresses only.
Public IP access is prohibited for database instances.
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class CloudSQLPrivateIPOnly(BaseResourceCheck):
    def __init__(self):
        name = "Ensure Cloud SQL instance uses private IP only"
        id = "CKV_GCP_CUSTOM_001"
        supported_resources = [
            "google_sql_database_instance"
        ]
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories,
                         supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Checks if Cloud SQL instance is configured with private IP only.

        Expected configuration:
        - settings.ip_configuration.ipv4_enabled = false
        - settings.ip_configuration.private_network is set
        """
        settings = conf.get("settings", [{}])
        if isinstance(settings, list) and len(settings) > 0:
            settings = settings[0]

        ip_configuration = settings.get("ip_configuration", [{}])
        if isinstance(ip_configuration, list) and len(ip_configuration) > 0:
            ip_configuration = ip_configuration[0]

        # Check if public IP is disabled
        ipv4_enabled = ip_configuration.get("ipv4_enabled", [True])
        if isinstance(ipv4_enabled, list):
            ipv4_enabled = ipv4_enabled[0] if ipv4_enabled else True

        # Check if private network is configured
        private_network = ip_configuration.get("private_network", [None])
        if isinstance(private_network, list):
            private_network = private_network[0] if private_network else None

        # Pass if public IP is disabled AND private network is set
        if ipv4_enabled is False and private_network:
            return CheckResult.PASSED

        return CheckResult.FAILED

    def get_evaluated_keys(self):
        return ["settings/ip_configuration/ipv4_enabled",
                "settings/ip_configuration/private_network"]


check = CloudSQLPrivateIPOnly()
