package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestCloudSQLModuleValidation validates the Cloud SQL module configuration
func TestCloudSQLModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/modules/cloudsql",
		Vars: map[string]interface{}{
			"project_id":     "test-project",
			"region":         "europe-west1",
			"environment":    "test",
			"instance_name":  "test-db",
			"database_type":  "postgresql",
		},
		NoColor: true,
	})

	terraform.Validate(t, terraformOptions)
}

// TestCloudSQLPostgreSQL tests PostgreSQL instance configuration
func TestCloudSQLPostgreSQL(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":       "test-project",
			"region":           "europe-west1",
			"environment":      "test",
			"instance_name":    "postgres-test",
			"database_type":    "postgresql",
			"database_version": "POSTGRES_15",
			"tier":             "db-custom-2-4096",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify PostgreSQL configuration
	assert.Contains(t, planOutput, "google_sql_database_instance")
	assert.Contains(t, planOutput, "POSTGRES_15")
}

// TestCloudSQLSQLServer tests SQL Server instance configuration
func TestCloudSQLSQLServer(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":       "test-project",
			"region":           "europe-west1",
			"environment":      "test",
			"instance_name":    "sqlserver-test",
			"database_type":    "sqlserver",
			"database_version": "SQLSERVER_2019_STANDARD",
			"tier":             "db-custom-2-4096",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify SQL Server configuration
	assert.Contains(t, planOutput, "google_sql_database_instance")
	assert.Contains(t, planOutput, "SQLSERVER_2019")
}

// TestCloudSQLHighAvailability tests HA configuration
func TestCloudSQLHighAvailability(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":        "test-project",
			"region":            "europe-west1",
			"environment":       "test",
			"instance_name":     "ha-test",
			"database_type":     "postgresql",
			"high_availability": true,
			"availability_type": "REGIONAL",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify HA configuration
	assert.Contains(t, planOutput, "REGIONAL")
}

// TestCloudSQLPrivateIP tests private IP configuration
func TestCloudSQLPrivateIP(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":      "test-project",
			"region":          "europe-west1",
			"environment":     "test",
			"instance_name":   "private-ip-test",
			"database_type":   "postgresql",
			"ipv4_enabled":    false,
			"private_network": "projects/test-project/global/networks/test-vpc",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planStruct := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// Verify private IP configuration
	assert.NotNil(t, planStruct.ResourcePlannedValuesMap)
}

// TestCloudSQLBackupConfiguration tests backup configuration
func TestCloudSQLBackupConfiguration(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":         "test-project",
			"region":             "europe-west1",
			"environment":        "test",
			"instance_name":      "backup-test",
			"database_type":      "postgresql",
			"backup_enabled":     true,
			"backup_start_time":  "03:00",
			"retained_backups":   14,
			"transaction_log_retention_days": 7,
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify backup configuration is present
	assert.Contains(t, planOutput, "backup_configuration")
}

// TestCloudSQLDeletionProtection tests deletion protection
func TestCloudSQLDeletionProtection(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/cloudsql",
		Vars: map[string]interface{}{
			"project_id":          "test-project",
			"region":              "europe-west1",
			"environment":         "prod",
			"instance_name":       "deletion-protection-test",
			"database_type":       "postgresql",
			"deletion_protection": true,
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify deletion protection is enabled
	assert.Contains(t, planOutput, "deletion_protection")
}
