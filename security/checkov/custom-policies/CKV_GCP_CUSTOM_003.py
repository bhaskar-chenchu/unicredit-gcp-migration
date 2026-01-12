"""
Custom Checkov Policy: VPC Flow Logs Must Be Enabled
Policy ID: CKV_GCP_CUSTOM_003
Severity: HIGH

UniCredit Security Requirement:
VPC subnets must have flow logs enabled for network traffic analysis
and security monitoring.
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class VPCFlowLogsEnabled(BaseResourceCheck):
    def __init__(self):
        name = "Ensure VPC subnet has flow logs enabled"
        id = "CKV_GCP_CUSTOM_003"
        supported_resources = [
            "google_compute_subnetwork"
        ]
        categories = [CheckCategories.LOGGING]
        super().__init__(name=name, id=id, categories=categories,
                         supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Checks if VPC subnet has flow logs enabled.

        Expected configuration:
        - log_config block should be present
        - log_config.aggregation_interval should be set
        - log_config.flow_sampling should be >= 0.5
        """
        log_config = conf.get("log_config", [])

        if not log_config:
            return CheckResult.FAILED

        if isinstance(log_config, list):
            if len(log_config) == 0:
                return CheckResult.FAILED
            log_config = log_config[0]

        if not isinstance(log_config, dict):
            return CheckResult.FAILED

        # Check if log_config has required fields
        aggregation_interval = log_config.get("aggregation_interval")
        flow_sampling = log_config.get("flow_sampling", [0])

        if isinstance(flow_sampling, list):
            flow_sampling = flow_sampling[0] if flow_sampling else 0

        # Flow sampling should be at least 0.5 (50%)
        try:
            if float(flow_sampling) >= 0.5:
                return CheckResult.PASSED
        except (TypeError, ValueError):
            pass

        return CheckResult.FAILED

    def get_evaluated_keys(self):
        return ["log_config", "log_config/aggregation_interval",
                "log_config/flow_sampling"]


check = VPCFlowLogsEnabled()
