#!/bin/bash

desired_replicas=5
current_replicas=$(kubectl get deployment web-deploy -o jsonpath='{.spec.replicas}')


# 1. Check replicas scaled to 5
if [[ "$current_replicas" != "$desired_replicas" ]]; then
    echo -e "Deployment should be scaled to 5 replicas, found spec.replicas=$desired_replicas$"
    exit 1
fi

# 2. Check that all 5 replicas are ready (rollout complete)
ready_replicas=$(kubectl get deployment web-deploy -o jsonpath='{.status.readyReplicas}')
if [[ "$ready_replicas" != "5" ]]; then
    echo -e "Not all replicas are ready: $ready_replicas/5 ready"
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
    echo -e "$log_file content does not match actual rollout history"
    echo -e "Expected:\n$actual_output"
    echo -e "Got:\n$file_content"
    exit 1
fi

# 3. Count revisions (lines containing "REVISION" and then numbers)
# Typical output:
# REVISION  STATUS    REASON
# 1         Completed
revision_count=$(echo "$actual_output" | grep -c "^[0-9]")

if [ "$revision_count" -ne 1 ]; then
    echo -e "Expected exactly 2 revisions, but found $revision_count"
    exit 1
fi

echo -e "Rollout history matches file and has exactly 1 revision"