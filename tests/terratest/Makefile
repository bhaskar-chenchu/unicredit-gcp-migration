# Makefile for Terratest

.PHONY: all init deps test test-network test-compute test-cloudsql test-iam test-lb clean

# Go settings
GO := go
GOFLAGS := -v
TEST_TIMEOUT := 30m

# Default target
all: deps test

# Initialize Go modules
init:
	$(GO) mod init github.com/unicredit/gcp-migration/tests/terratest || true
	$(GO) mod tidy

# Download dependencies
deps:
	$(GO) mod download
	$(GO) mod tidy

# Run all tests
test:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) ./...

# Run specific module tests
test-network:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run TestNetwork ./...

test-compute:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run TestCompute ./...

test-cloudsql:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run TestCloudSQL ./...

test-iam:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run TestIAM ./...

test-lb:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run TestLoadBalancer ./...

# Run validation tests only (no apply)
test-validate:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run ".*Validation.*" ./...

# Run plan tests only (no apply)
test-plan:
	$(GO) test $(GOFLAGS) -timeout $(TEST_TIMEOUT) -run ".*Plan.*" ./...

# Clean up
clean:
	rm -rf fixtures/*/.terraform
	rm -rf fixtures/*/.terraform.lock.hcl
	rm -rf fixtures/*/terraform.tfstate*
	rm -rf fixtures/*/*.out
	$(GO) clean -testcache

# Format code
fmt:
	$(GO) fmt ./...

# Lint code
lint:
	golangci-lint run ./...

# Help
help:
	@echo "Available targets:"
	@echo "  all          - Download deps and run all tests"
	@echo "  init         - Initialize Go modules"
	@echo "  deps         - Download dependencies"
	@echo "  test         - Run all tests"
	@echo "  test-network - Run network module tests"
	@echo "  test-compute - Run compute module tests"
	@echo "  test-cloudsql- Run Cloud SQL module tests"
	@echo "  test-iam     - Run IAM module tests"
	@echo "  test-lb      - Run load balancer module tests"
	@echo "  test-validate- Run validation tests only"
	@echo "  test-plan    - Run plan tests only"
	@echo "  clean        - Clean up test artifacts"
	@echo "  fmt          - Format Go code"
	@echo "  lint         - Lint Go code"
