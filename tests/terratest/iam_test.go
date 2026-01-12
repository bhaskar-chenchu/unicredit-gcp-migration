package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestIAMModuleValidation validates the IAM module configuration
func TestIAMModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/modules/iam",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"environment": "test",
		},
		NoColor: true,
	})

	terraform.Validate(t, terraformOptions)
}

// TestIAMServiceAccountCreation tests service account creation
func TestIAMServiceAccountCreation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/iam",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"environment": "test",
			"service_accounts": []map[string]interface{}{
				{
					"account_id":   "app-a-sa",
					"display_name": "App A Service Account",
					"description":  "Service account for App A",
				},
				{
					"account_id":   "app-b-sa",
					"display_name": "App B Service Account",
					"description":  "Service account for App B",
				},
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify service accounts are created
	assert.Contains(t, planOutput, "google_service_account")
	assert.Contains(t, planOutput, "app-a-sa")
	assert.Contains(t, planOutput, "app-b-sa")
}

// TestIAMRoleBindings tests IAM role bindings
func TestIAMRoleBindings(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/iam",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"environment": "test",
			"role_bindings": []map[string]interface{}{
				{
					"role":    "roles/compute.instanceAdmin.v1",
					"members": []string{"serviceAccount:app-a-sa@test-project.iam.gserviceaccount.com"},
				},
				{
					"role":    "roles/cloudsql.client",
					"members": []string{"serviceAccount:app-a-sa@test-project.iam.gserviceaccount.com"},
				},
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify role bindings
	assert.Contains(t, planOutput, "google_project_iam_member")
}

// TestIAMNoPublicAccess tests that no public access is granted
func TestIAMNoPublicAccess(t *testing.T) {
	t.Parallel()

	// This test validates that allUsers and allAuthenticatedUsers are not used
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/iam",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"environment": "test",
			"role_bindings": []map[string]interface{}{
				{
					"role":    "roles/viewer",
					"members": []string{"user:admin@unicredit.example.com"},
				},
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify no public access principals
	assert.NotContains(t, planOutput, "allUsers")
	assert.NotContains(t, planOutput, "allAuthenticatedUsers")
}

// TestIAMWorkloadIdentity tests Workload Identity configuration
func TestIAMWorkloadIdentity(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/iam",
		Vars: map[string]interface{}{
			"project_id":               "test-project",
			"environment":              "test",
			"enable_workload_identity": true,
			"workload_identity_config": map[string]interface{}{
				"namespace":           "default",
				"service_account":     "app-sa",
				"gcp_service_account": "app-sa@test-project.iam.gserviceaccount.com",
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify Workload Identity binding
	assert.Contains(t, planOutput, "google_service_account_iam_member")
}

// TestIAMLeastPrivilege tests least privilege principle
func TestIAMLeastPrivilege(t *testing.T) {
	t.Parallel()

	// Define expected roles for each service account type
	testCases := []struct {
		name          string
		accountType   string
		expectedRoles []string
	}{
		{
			name:        "app_service_account",
			accountType: "application",
			expectedRoles: []string{
				"roles/cloudsql.client",
				"roles/logging.logWriter",
				"roles/monitoring.metricWriter",
			},
		},
		{
			name:        "compute_service_account",
			accountType: "compute",
			expectedRoles: []string{
				"roles/compute.instanceAdmin.v1",
				"roles/iam.serviceAccountUser",
			},
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: "./fixtures/iam",
				Vars: map[string]interface{}{
					"project_id":   "test-project",
					"environment":  "test",
					"account_type": tc.accountType,
				},
				NoColor: true,
			})

			terraform.Init(t, terraformOptions)
			planOutput := terraform.Plan(t, terraformOptions)

			// Verify expected roles are assigned
			for _, role := range tc.expectedRoles {
				assert.Contains(t, planOutput, role)
			}

			// Verify overly permissive roles are not used
			assert.NotContains(t, planOutput, "roles/owner")
			assert.NotContains(t, planOutput, "roles/editor")
		})
	}
}
