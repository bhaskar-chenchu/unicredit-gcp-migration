package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestLoadBalancerModuleValidation validates the load balancer module
func TestLoadBalancerModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/modules/load-balancer",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"name":        "test-lb",
		},
		NoColor: true,
	})

	terraform.Validate(t, terraformOptions)
}

// TestLoadBalancerHTTPS tests HTTPS load balancer configuration
func TestLoadBalancerHTTPS(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/load-balancer",
		Vars: map[string]interface{}{
			"project_id":   "test-project",
			"region":       "europe-west1",
			"environment":  "test",
			"name":         "https-lb-test",
			"enable_https": true,
			"ssl_policy":   "MODERN",
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify HTTPS configuration
	assert.Contains(t, planOutput, "google_compute_global_forwarding_rule")
	assert.Contains(t, planOutput, "google_compute_target_https_proxy")
	assert.Contains(t, planOutput, "google_compute_ssl_certificate")
}

// TestLoadBalancerBackendService tests backend service configuration
func TestLoadBalancerBackendService(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/load-balancer",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"name":        "backend-test",
			"backends": []map[string]interface{}{
				{
					"group":           "projects/test-project/regions/europe-west1/instanceGroups/app-a-mig",
					"balancing_mode":  "UTILIZATION",
					"capacity_scaler": 1.0,
				},
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify backend service
	assert.Contains(t, planOutput, "google_compute_backend_service")
}

// TestLoadBalancerHealthCheck tests health check configuration
func TestLoadBalancerHealthCheck(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/load-balancer",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"name":        "health-check-test",
			"health_check": map[string]interface{}{
				"check_interval_sec":  10,
				"timeout_sec":         5,
				"healthy_threshold":   2,
				"unhealthy_threshold": 3,
				"request_path":        "/health",
				"port":                8080,
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify health check
	assert.Contains(t, planOutput, "google_compute_health_check")
	assert.Contains(t, planOutput, "/health")
}

// TestLoadBalancerURLMap tests URL map configuration
func TestLoadBalancerURLMap(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/load-balancer",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"name":        "url-map-test",
			"url_map_rules": []map[string]interface{}{
				{
					"hosts":        []string{"app-a.example.com"},
					"path_matcher": "app-a-paths",
					"backend":      "app-a-backend",
				},
				{
					"hosts":        []string{"app-b.example.com"},
					"path_matcher": "app-b-paths",
					"backend":      "app-b-backend",
				},
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify URL map
	assert.Contains(t, planOutput, "google_compute_url_map")
}

// TestLoadBalancerSSLPolicy tests SSL policy configuration
func TestLoadBalancerSSLPolicy(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name       string
		sslProfile string
		minVersion string
	}{
		{
			name:       "modern_profile",
			sslProfile: "MODERN",
			minVersion: "TLS_1_2",
		},
		{
			name:       "restricted_profile",
			sslProfile: "RESTRICTED",
			minVersion: "TLS_1_2",
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: "./fixtures/load-balancer",
				Vars: map[string]interface{}{
					"project_id":      "test-project",
					"region":          "europe-west1",
					"environment":     "test",
					"name":            "ssl-policy-test",
					"ssl_policy":      tc.sslProfile,
					"min_tls_version": tc.minVersion,
				},
				NoColor: true,
			})

			terraform.Init(t, terraformOptions)
			planOutput := terraform.Plan(t, terraformOptions)

			// Verify SSL policy
			assert.Contains(t, planOutput, "google_compute_ssl_policy")
			assert.Contains(t, planOutput, tc.sslProfile)
		})
	}
}

// TestLoadBalancerCDN tests Cloud CDN configuration
func TestLoadBalancerCDN(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures/load-balancer",
		Vars: map[string]interface{}{
			"project_id":  "test-project",
			"region":      "europe-west1",
			"environment": "test",
			"name":        "cdn-test",
			"enable_cdn":  true,
			"cdn_policy": map[string]interface{}{
				"cache_mode":                   "CACHE_ALL_STATIC",
				"default_ttl":                  3600,
				"max_ttl":                      86400,
				"negative_caching":             true,
				"serve_while_stale":            86400,
			},
		},
		NoColor: true,
	})

	terraform.Init(t, terraformOptions)
	planOutput := terraform.Plan(t, terraformOptions)

	// Verify CDN is enabled
	assert.Contains(t, planOutput, "enable_cdn")
}
