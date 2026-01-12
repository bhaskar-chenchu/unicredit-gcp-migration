#!/bin/bash
# InSpec Compliance Testing Runner
# Usage: ./run-inspec.sh <profile> <target> [options]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_DIR="${SCRIPT_DIR}/inspec/profiles"
REPORTS_DIR="${SCRIPT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
PROFILE=""
TARGET=""
WAIVER_FILE=""
REPORTER="cli"

# Show usage
usage() {
    echo "Usage: $0 <profile> <target> [options]"
    echo ""
    echo "Profiles:"
    echo "  unicredit-baseline     - Base compliance controls"
    echo "  rhel9-hardening        - RHEL 9 CIS Benchmark controls"
    echo "  windows2022-hardening  - Windows 2022 CIS Benchmark controls"
    echo ""
    echo "Targets:"
    echo "  local                  - Run against local system"
    echo "  ssh://user@host        - Run against remote Linux host"
    echo "  winrm://user@host      - Run against remote Windows host"
    echo ""
    echo "Options:"
    echo "  --waiver FILE          - Apply waiver file"
    echo "  --reporter FORMAT      - Output format (cli, json, html, junit)"
    echo "  --attrs FILE           - Attributes file"
    echo "  --help                 - Show this help"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        unicredit-baseline|rhel9-hardening|windows2022-hardening)
            PROFILE=$1
            shift
            ;;
        local|ssh://*|winrm://*)
            TARGET=$1
            shift
            ;;
        --waiver)
            WAIVER_FILE=$2
            shift 2
            ;;
        --reporter)
            REPORTER=$2
            shift 2
            ;;
        --attrs)
            ATTRS_FILE=$2
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate inputs
if [[ -z "$PROFILE" ]] || [[ -z "$TARGET" ]]; then
    echo -e "${RED}Error: Profile and target are required${NC}"
    usage
fi

PROFILE_PATH="${PROFILES_DIR}/${PROFILE}"
if [[ ! -d "$PROFILE_PATH" ]]; then
    echo -e "${RED}Error: Profile not found: ${PROFILE_PATH}${NC}"
    exit 1
fi

# Create reports directory
mkdir -p "${REPORTS_DIR}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  InSpec Compliance Testing${NC}"
echo -e "${BLUE}  Profile: ${PROFILE}${NC}"
echo -e "${BLUE}  Target: ${TARGET}${NC}"
echo -e "${BLUE}========================================${NC}"

# Build InSpec command
INSPEC_CMD="inspec exec ${PROFILE_PATH}"

# Add target
if [[ "$TARGET" != "local" ]]; then
    INSPEC_CMD="${INSPEC_CMD} -t ${TARGET}"
fi

# Add reporters
case $REPORTER in
    cli)
        INSPEC_CMD="${INSPEC_CMD} --reporter cli"
        ;;
    json)
        INSPEC_CMD="${INSPEC_CMD} --reporter json:${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}.json"
        ;;
    html)
        INSPEC_CMD="${INSPEC_CMD} --reporter html:${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}.html"
        ;;
    junit)
        INSPEC_CMD="${INSPEC_CMD} --reporter junit:${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}.xml"
        ;;
    all)
        INSPEC_CMD="${INSPEC_CMD} --reporter cli json:${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}.json html:${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}.html"
        ;;
esac

# Add waiver file if specified
if [[ -n "$WAIVER_FILE" ]]; then
    INSPEC_CMD="${INSPEC_CMD} --waiver-file ${WAIVER_FILE}"
fi

# Add attributes file if specified
if [[ -n "$ATTRS_FILE" ]]; then
    INSPEC_CMD="${INSPEC_CMD} --input-file ${ATTRS_FILE}"
fi

# Run InSpec
echo -e "\n${GREEN}Running InSpec...${NC}"
echo "Command: ${INSPEC_CMD}"
echo ""

if eval ${INSPEC_CMD}; then
    echo -e "\n${GREEN}✓ Compliance check completed successfully${NC}"
    EXIT_CODE=0
else
    echo -e "\n${YELLOW}⚠ Compliance check completed with findings${NC}"
    EXIT_CODE=$?
fi

# Summary
if [[ "$REPORTER" != "cli" ]]; then
    echo -e "\n${BLUE}Reports saved to: ${REPORTS_DIR}/${NC}"
    ls -la "${REPORTS_DIR}/${PROFILE}_${TIMESTAMP}"* 2>/dev/null || true
fi

exit ${EXIT_CODE}
