#!/bin/bash

# Expected image and command
expected_image="nginx"
expected_version="1.22"

current_image=$(kubectl get deployment web-deploy -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$current_image" != "${expected_image}:${expected_version}" ]]; then
    echo -e "${RED}✗ Image should be ${expected_image}:${expected_version}, found $current_image${NC}"
    exit 1
fi

# Check file and its contets
log_file="/opt/rollout.log"

if [ ! -f "$log_file" ]; then
    echo -e "$log_file does not exist${NC}"
    exit 1
fi

# 1. Get actual rollout history
actual_output=$(kubectl rollout history deployment web-deploy 2>/dev/null)
if [ $? -ne 0 ]; then
    echo -e "Failed to get rollout history from cluster"
    exit 1
fi

# 2. Compare file content with actual rollout history
file_content=$(cat "$log_file")
if [ "$actual_output" != "$file_content" ]; then
    echo -e "${RED}✗ $log_file content does not match actual rollout history${NC}"
    echo -e "Expected:\n$actual_output"
    echo -e "Got:\n$file_content"
    exit 1
fi

# 3. Count revisions (lines containing "REVISION" and then numbers)
# Typical output:
# REVISION  STATUS    REASON
# 1         Completed
# 2         Completed
revision_count=$(echo "$actual_output" | grep -c "^[0-9]")

if [ "$revision_count" -ne 2 ]; then
    echo -e "${RED}✗ Expected exactly 2 revisions, but found $revision_count${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Rollout history matches file and has exactly 2 revisions${NC}"