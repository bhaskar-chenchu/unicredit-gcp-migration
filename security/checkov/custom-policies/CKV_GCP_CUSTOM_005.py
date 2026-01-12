"""
Custom Checkov Policy: Cloud SQL Must Have Backup Enabled
Policy ID: CKV_GCP_CUSTOM_005
Severity: HIGH

UniCredit Security Requirement:
All Cloud SQL instances must have automated backups enabled
with a minimum retention period of 7 days.
"""

from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckCategories, CheckResult


class CloudSQLBackupEnabled(BaseResourceCheck):
    def __init__(self):
        name = "Ensure Cloud SQL has backup enabled with adequate retention"
        id = "CKV_GCP_CUSTOM_005"
        supported_resources = [
            "google_sql_database_instance"
        ]
        categories = [CheckCategories.BACKUP_AND_RECOVERY]
        super().__init__(name=name, id=id, categories=categories,
                         supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Checks if Cloud SQL instance has backup enabled with retention.

        Expected configuration:
        - settings.backup_configuration.enabled = true
        - settings.backup_configuration.transaction_log_retention_days >= 7
        - settings.backup_configuration.backup_retention_settings.retained_backups >= 7
        """
        settings = conf.get("settings", [{}])
        if isinstance(settings, list) and len(settings) > 0:
            settings = settings[0]

        backup_config = settings.get("backup_configuration", [{}])
        if isinstance(backup_config, list) and len(backup_config) > 0:
            backup_config = backup_config[0]

        # Check if backup is enabled
        enabled = backup_config.get("enabled", [False])
        if isinstance(enabled, list):
            enabled = enabled[0] if enabled else False

        if not enabled:
            return CheckResult.FAILED

        # Check transaction log retention (for point-in-time recovery)
        log_retention = backup_config.get("transaction_log_retention_days", [7])
        if isinstance(log_retention, list):
            log_retention = log_retention[0] if log_retention else 7

        try:
            if int(log_retention) < 7:
                return CheckResult.FAILED
        except (TypeError, ValueError):
            pass

        # Check backup retention settings
        retention_settings = backup_config.get("backup_retention_settings", [{}])
        if isinstance(retention_settings, list) and len(retention_settings) > 0:
            retention_settings = retention_settings[0]

        if isinstance(retention_settings, dict):
            retained_backups = retention_settings.get("retained_backups", [7])
            if isinstance(retained_backups, list):
                retained_backups = retained_backups[0] if retained_backups else 7

            try:
                if int(retained_backups) < 7:
                    return CheckResult.FAILED
            except (TypeError, ValueError):
                pass

        return CheckResult.PASSED

    def get_evaluated_keys(self):
        return ["settings/backup_configuration/enabled",
                "settings/backup_configuration/transaction_log_retention_days",
                "settings/backup_configuration/backup_retention_settings/retained_backups"]


check = CloudSQLBackupEnabled()
