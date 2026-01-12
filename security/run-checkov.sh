#!/bin/bash
# Checkov Security Scanner Runner
# Usage: ./run-checkov.sh [environment] [--baseline]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
REPORTS_DIR="${SCRIPT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
ENVIRONMENT="${1:-dev}"
CREATE_BASELINE=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --baseline)
            CREATE_BASELINE=true
            shift
            ;;
        --help)
            echo "Usage: ./run-checkov.sh [environment] [--baseline]"
            echo ""
            echo "Arguments:"
            echo "  environment    Target environment (dev, staging, prod). Default: dev"
            echo "  --baseline     Create a new baseline from current scan results"
            echo ""
            echo "Examples:"
            echo "  ./run-checkov.sh                    # Scan dev environment"
            echo "  ./run-checkov.sh staging            # Scan staging environment"
            echo "  ./run-checkov.sh dev --baseline     # Create baseline for dev"
            exit 0
            ;;
    esac
done

# Ensure reports directory exists
mkdir -p "${REPORTS_DIR}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Checkov Security Scanner${NC}"
echo -e "${BLUE}  Environment: ${ENVIRONMENT}${NC}"
echo -e "${BLUE}========================================${NC}"

# Check if checkov is installed
if ! command -v checkov &> /dev/null; then
    echo -e "${YELLOW}Checkov not found. Installing...${NC}"
    pip install checkov
fi

# Navigate to project root
cd "${PROJECT_ROOT}"

# Run Checkov scan
echo -e "\n${GREEN}Running Checkov scan...${NC}"

CHECKOV_ARGS=(
    "--config-file" "security/checkov/.checkov.yml"
    "--directory" "terraform/modules"
    "--directory" "terraform/environments/${ENVIRONMENT}"
    "--external-checks-dir" "security/checkov/custom-policies"
    "--output" "cli"
    "--output" "json"
    "--output" "junitxml"
    "--output-file-path" "${REPORTS_DIR}"
)

# Add baseline if not creating one
if [ "$CREATE_BASELINE" = false ] && [ -f "security/checkov/baseline/checkov-baseline.json" ]; then
    CHECKOV_ARGS+=("--baseline" "security/checkov/baseline/checkov-baseline.json")
fi

# Run the scan
if checkov "${CHECKOV_ARGS[@]}"; then
    echo -e "\n${GREEN}✓ Checkov scan completed successfully${NC}"
    SCAN_RESULT=0
else
    echo -e "\n${RED}✗ Checkov scan found security issues${NC}"
    SCAN_RESULT=1
fi

# Rename output files with timestamp
if [ -f "${REPORTS_DIR}/results_cli.txt" ]; then
    mv "${REPORTS_DIR}/results_cli.txt" "${REPORTS_DIR}/checkov_${ENVIRONMENT}_${TIMESTAMP}.txt"
fi

if [ -f "${REPORTS_DIR}/results_json.json" ]; then
    mv "${REPORTS_DIR}/results_json.json" "${REPORTS_DIR}/checkov_${ENVIRONMENT}_${TIMESTAMP}.json"
fi

if [ -f "${REPORTS_DIR}/results_junitxml.xml" ]; then
    mv "${REPORTS_DIR}/results_junitxml.xml" "${REPORTS_DIR}/checkov_${ENVIRONMENT}_${TIMESTAMP}.xml"
fi

# Create baseline if requested
if [ "$CREATE_BASELINE" = true ]; then
    echo -e "\n${YELLOW}Creating new baseline...${NC}"
    checkov \
        --directory "terraform/modules" \
        --directory "terraform/environments/${ENVIRONMENT}" \
        --external-checks-dir "security/checkov/custom-policies" \
        --create-baseline \
        --output-baseline-as-skipped

    if [ -f ".checkov.baseline" ]; then
        mv ".checkov.baseline" "security/checkov/baseline/checkov-baseline.json"
        echo -e "${GREEN}✓ Baseline created at security/checkov/baseline/checkov-baseline.json${NC}"
    fi
fi

# Summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}  Scan Complete${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Reports saved to: ${REPORTS_DIR}/"
echo -e "  - checkov_${ENVIRONMENT}_${TIMESTAMP}.txt"
echo -e "  - checkov_${ENVIRONMENT}_${TIMESTAMP}.json"
echo -e "  - checkov_${ENVIRONMENT}_${TIMESTAMP}.xml"

exit ${SCAN_RESULT}
