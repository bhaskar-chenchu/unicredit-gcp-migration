#!/bin/bash
# Molecule Tests Runner Script
# Usage: ./run-molecule-tests.sh [role_name] [scenario]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROLES_DIR="${SCRIPT_DIR}/roles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to run molecule tests for a role
run_molecule_test() {
    local role_name=$1
    local scenario=${2:-default}
    local role_path="${ROLES_DIR}/${role_name}"

    if [[ ! -d "${role_path}/molecule/${scenario}" ]]; then
        echo -e "${YELLOW}Skipping ${role_name}: No molecule/${scenario} directory${NC}"
        return 0
    fi

    echo -e "${GREEN}Running Molecule tests for: ${role_name} (${scenario})${NC}"
    cd "${role_path}"

    if molecule test -s "${scenario}"; then
        echo -e "${GREEN}✓ ${role_name} passed${NC}"
        return 0
    else
        echo -e "${RED}✗ ${role_name} failed${NC}"
        return 1
    fi
}

# Function to run all Linux role tests
run_linux_tests() {
    local failed=0
    local linux_roles=("wildfly" "java_app" "postgresql_client" "sqlserver_client")

    echo "Running Linux role tests..."
    for role in "${linux_roles[@]}"; do
        if ! run_molecule_test "${role}"; then
            ((failed++))
        fi
    done

    return ${failed}
}

# Function to run all Windows role tests
run_windows_tests() {
    local failed=0
    local windows_roles=("iis" "dotnet_app")

    # Check for required Windows environment variables
    if [[ -z "${MOLECULE_WINDOWS_HOST}" ]]; then
        echo -e "${YELLOW}Skipping Windows tests: MOLECULE_WINDOWS_HOST not set${NC}"
        return 0
    fi

    echo "Running Windows role tests..."
    for role in "${windows_roles[@]}"; do
        if ! run_molecule_test "${role}"; then
            ((failed++))
        fi
    done

    return ${failed}
}

# Main execution
main() {
    local role_name=$1
    local scenario=${2:-default}
    local failed=0

    cd "${SCRIPT_DIR}"

    # Install Galaxy requirements
    echo "Installing Ansible Galaxy requirements..."
    ansible-galaxy collection install -r molecule-requirements.yml

    if [[ -n "${role_name}" ]]; then
        # Run specific role test
        if ! run_molecule_test "${role_name}" "${scenario}"; then
            exit 1
        fi
    else
        # Run all tests
        echo "Running all Molecule tests..."

        if ! run_linux_tests; then
            ((failed++))
        fi

        if ! run_windows_tests; then
            ((failed++))
        fi

        if [[ ${failed} -gt 0 ]]; then
            echo -e "${RED}Some tests failed${NC}"
            exit 1
        fi
    fi

    echo -e "${GREEN}All tests passed!${NC}"
}

main "$@"
