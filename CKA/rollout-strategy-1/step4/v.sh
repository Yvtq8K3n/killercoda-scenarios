#!/bin/bash

# Configuration – adjust this to the deployment name expected in the task
EXPECTED_DEPLOYMENT="web-deploy"   # ← change as needed
LOG_FILE="/opt/rollout2.log"

if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "$LOG_FILE does not exist${NC}"
    exit 1
fi

# Check for the exact success message including deployment name
# Example: deployment "web-deploy" successfully rolled out
if grep -qi "deployment \"${EXPECTED_DEPLOYMENT}\" successfully rolled out" "$LOG_FILE"; then
    echo -e "$LOG_FILE contains correct rollout status for ${EXPECTED_DEPLOYMENT}${NC}"
else
    echo -e "$LOG_FILE does not contain 'deployment \"${EXPECTED_DEPLOYMENT}\" successfully rolled out'${NC}"
    exit 1
fi

# Optional: check that --watch was used (at least 2 lines)
line_count=$(wc -l < "$LOG_FILE")
if [[ $line_count -ge 2 ]]; then
    echo -e "Log has $line_count lines (--watch likely used)${NC}"
else
    echo -e "Log has only $line_count line; --watch may be missing${NC}"
    exit 1
fi