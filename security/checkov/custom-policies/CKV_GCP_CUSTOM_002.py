"""
Custom Checkov Policy: Compute Instances Must Not Have Public IPs
Policy ID: CKV_GCP_CUSTOM_002
Severity: HIGH

UniCredit Security Requirement:
Compute instances must not have external (public) IP addresses.
All external access must go through the load balancer or Cloud NAT.
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class ComputeInstanceNoPublicIP(BaseResourceCheck):
    def __init__(self):
        name = "Ensure Compute instance does not have public IP"
        id = "CKV_GCP_CUSTOM_002"
        supported_resources = [
            "google_compute_instance",
            "google_compute_instance_template",
            "google_compute_instance_from_template"
        ]
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories,
                         supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Checks if compute instance has no public IP.

        Expected configuration:
        - network_interface.access_config should NOT be present, OR
        - network_interface.access_config should be empty
        """
        network_interfaces = conf.get("network_interface", [])

        if not network_interfaces:
            # No network interface defined - pass (will fail elsewhere)
            return CheckResult.PASSED

        if isinstance(network_interfaces, dict):
            network_interfaces = [network_interfaces]

        for ni in network_interfaces:
            if isinstance(ni, dict):
                access_config = ni.get("access_config", [])

                # If access_config exists and is not empty, instance has public IP
                if access_config:
                    if isinstance(access_config, list) and len(access_config) > 0:
                        # Check if it's not just an empty block
                        for ac in access_config:
                            if ac and isinstance(ac, dict):
                                return CheckResult.FAILED
                    elif isinstance(access_config, dict):
                        return CheckResult.FAILED

        return CheckResult.PASSED

    def get_evaluated_keys(self):
        return ["network_interface/access_config"]


check = ComputeInstanceNoPublicIP()
