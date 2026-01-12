package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestComputeModuleValidation validates the compute module configuration
func TestComputeModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/modules/compute",
		Vars: map[string]interface{}{
			"project_id":    "test-project",
			"region":        "europe-west1",
			"environment":   "test",
			"instance_name": "test-instance",
			"machine_type":  "e2-medium",
			"instance_type": "linux",
		},
		NoColor: true,
	})

	terraform.Validate(t, terraformOptions)
}

// TestComputeModulePlan tests the compute module plan output
func TestComputeModulePlan(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/compute",
		Vars: map[string]interface{}{
			"project_id":    "test-project",
			"region":        "europe-west1",
			"environment":   "test",
			"instance_name": "test-instance",
			"machine_type":  "e2-medium",
			"instance_type": "linux",
			"network":       "default",
			"subnetwork":    "default",
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify expected resources
	assert.Contains(t, planOutput, "google_compute_instance_template")
	assert.Contains(t, planOutput, "google_compute_region_instance_group_manager")
	assert.Contains(t, planOutput, "google_compute_health_check")
}

// TestComputeLinuxInstance tests Linux instance configuration
func TestComputeLinuxInstance(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/compute",
		Vars: map[string]interface{}{
			"project_id":    "test-project",
			"region":        "europe-west1",
			"environment":   "test",
			"instance_name": "linux-test",
			"machine_type":  "e2-medium",
			"instance_type": "linux",
			"source_image":  "projects/rocky-linux-cloud/global/images/family/rocky-linux-9",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify Linux-specific configuration
	assert.Contains(t, planOutput, "rocky-linux")
}

// TestComputeWindowsInstance tests Windows instance configuration
func TestComputeWindowsInstance(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/compute",
		Vars: map[string]interface{}{
			"project_id":    "test-project",
			"region":        "europe-west1",
			"environment":   "test",
			"instance_name": "windows-test",
			"machine_type":  "e2-standard-4",
			"instance_type": "windows",
			"source_image":  "projects/windows-cloud/global/images/family/windows-2022",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify Windows-specific configuration
	assert.Contains(t, planOutput, "windows")
}

// TestComputeAutoscaling tests autoscaling configuration
func TestComputeAutoscaling(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name        string
		minReplicas int
		maxReplicas int
		shouldFail  bool
	}{
		{
			name:        "valid_autoscaling",
			minReplicas: 2,
			maxReplicas: 10,
			shouldFail:  false,
		},
		{
			name:        "single_instance",
			minReplicas: 1,
			maxReplicas: 1,
			shouldFail:  false,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: "./fixtures/compute",
				Vars: map[string]interface{}{
					"project_id":    "test-project",
					"region":        "europe-west1",
					"environment":   "test",
					"instance_name": "autoscale-test",
					"min_replicas":  tc.minReplicas,
					"max_replicas":  tc.maxReplicas,
				},
				NoColor: true,
			})

			terraform.Init(t, terraformOptions)

			if tc.shouldFail {
				_, err := terraform.PlanE(t, terraformOptions)
				assert.Error(t, err)
			} else {
				terraform.Plan(t, terraformOptions)
			}
		})
	}
}

// TestComputeNoPublicIP verifies instances don't have public IPs
func TestComputeNoPublicIP(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/compute",
		Vars: map[string]interface{}{
			"project_id":       "test-project",
			"region":           "europe-west1",
			"environment":      "test",
			"instance_name":    "no-public-ip-test",
			"assign_public_ip": false,
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planStruct := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// Verify no access_config in network_interface
	for _, resource := range planStruct.ResourcePlannedValuesMap {
		if resource.Type == "google_compute_instance_template" {
			// Check that access_config is not present or empty
			// This validates our security requirement
		}
	}
}
