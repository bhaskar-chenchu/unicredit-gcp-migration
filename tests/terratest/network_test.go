package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestNetworkModuleValidation validates the network module configuration
func TestNetworkModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/modules/network",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
		},
		NoColor: true,
	})

	// Validate the Terraform configuration
	terraform.Validate(t, terraformOptions)
}

// TestNetworkModulePlan tests the network module plan output
func TestNetworkModulePlan(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/network",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
		},
		NoColor:    true,
		PlanFilePath: "./network-plan.out",
	})

	// Clean up at the end
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and plan
	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify plan contains expected resources
	assert.Contains(t, planOutput, "google_compute_network.vpc")
	assert.Contains(t, planOutput, "google_compute_subnetwork.public")
	assert.Contains(t, planOutput, "google_compute_subnetwork.private")
	assert.Contains(t, planOutput, "google_compute_router.router")
	assert.Contains(t, planOutput, "google_compute_router_nat.nat")
}

// TestNetworkModuleOutputs tests the network module outputs
func TestNetworkModuleOutputs(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/network",
		Vars: map[string]interface{}{
			"project_id":        "test-project",
			"region":            "europe-west1",
			"environment":       "test",
			"vpc_name":          "test-vpc",
			"public_subnet_cidr": "10.0.1.0/24",
			"private_subnet_cidr": "10.0.2.0/24",
		},
		NoColor: true,
	})

	// Initialize
	terraform.Init(t, terraformOptions)

	// Get expected outputs from plan
	planStruct := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// Verify outputs are defined
	require.NotNil(t, planStruct.ResourcePlannedValuesMap)
}

// TestNetworkCIDRValidation validates CIDR configurations
func TestNetworkCIDRValidation(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name        string
		publicCIDR  string
		privateCIDR string
		shouldFail  bool
	}{
		{
			name:        "valid_cidrs",
			publicCIDR:  "10.0.1.0/24",
			privateCIDR: "10.0.2.0/24",
			shouldFail:  false,
		},
		{
			name:        "valid_larger_cidrs",
			publicCIDR:  "10.0.0.0/20",
			privateCIDR: "10.0.16.0/20",
			shouldFail:  false,
		},
	}

	for _, tc := range testCases {
		tc := tc // capture range variable
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: "./fixtures/network",
				Vars: map[string]interface{}{
					"project_id":         "test-project",
					"region":             "europe-west1",
					"environment":        "test",
					"public_subnet_cidr":  tc.publicCIDR,
					"private_subnet_cidr": tc.privateCIDR,
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

// TestNetworkFirewallRules validates firewall rule configurations
func TestNetworkFirewallRules(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/network",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"enable_ssh_firewall": true,
			"enable_http_firewall": true,
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify firewall rules are in the plan
	assert.Contains(t, planOutput, "google_compute_firewall")
}
