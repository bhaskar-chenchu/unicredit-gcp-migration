"""
Custom Checkov Policy: IAM Bindings Must Not Use Public Access
Policy ID: CKV_GCP_CUSTOM_004
Severity: CRITICAL

UniCredit Security Requirement:
IAM bindings must not grant access to allUsers or allAuthenticatedUsers.
All access must be explicitly granted to specific identities.
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class IAMNoPublicAccess(BaseResourceCheck):
    def __init__(self):
        name = "Ensure IAM binding does not grant public access"
        id = "CKV_GCP_CUSTOM_004"
        supported_resources = [
            "google_project_iam_binding",
            "google_project_iam_member",
            "google_storage_bucket_iam_binding",
            "google_storage_bucket_iam_member",
            "google_compute_instance_iam_binding",
            "google_compute_instance_iam_member",
            "google_cloudsql_database_instance_iam_binding",
            "google_cloudsql_database_instance_iam_member",
            "google_pubsub_topic_iam_binding",
            "google_pubsub_topic_iam_member",
            "google_pubsub_subscription_iam_binding",
            "google_pubsub_subscription_iam_member"
        ]
        categories = [CheckCategories.IAM]
        super().__init__(name=name, id=id, categories=categories,
                         supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Checks if IAM binding grants access to public principals.

        Prohibited principals:
        - allUsers
        - allAuthenticatedUsers
        """
        prohibited_principals = ["allUsers", "allAuthenticatedUsers"]

        # Check 'member' field (for *_iam_member resources)
        member = conf.get("member", [])
        if isinstance(member, list):
            member = member[0] if member else ""

        if member in prohibited_principals:
            return CheckResult.FAILED

        # Check 'members' field (for *_iam_binding resources)
        members = conf.get("members", [])
        if isinstance(members, list):
            for m in members:
                if isinstance(m, list):
                    for sub_m in m:
                        if sub_m in prohibited_principals:
                            return CheckResult.FAILED
                elif m in prohibited_principals:
                    return CheckResult.FAILED

        return CheckResult.PASSED

    def get_evaluated_keys(self):
        return ["member", "members"]


check = IAMNoPublicAccess()
