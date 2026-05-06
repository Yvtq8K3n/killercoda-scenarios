#!/bin/bash

current_replicas=$(kubectl get deployment web-deploy -o jsonpath='{.status.readyReplicas}')
desired_replicas=$(kubectl get deployment web-deploy -o jsonpath='{.spec.replicas}')

# 1. Check replicas scaled to 5
if [[ "$desired_replicas" != "5" ]]; then
    echo -e "${RED}✗ Deployment should be scaled to 5 replicas, found spec.replicas=$desired_replicas${NC}"
    exit 1
fi

# 2. Check that all 5 replicas are ready (rollout complete)
ready_replicas=$(kubectl get deployment web-deploy -o jsonpath='{.status.readyReplicas}')
if [[ "$ready_replicas" != "5" ]]; then
    echo -e "${RED}✗ Not all replicas are ready: $ready_replicas/5 ready. Run rollout status to debug.${NC}"
    exit 1

# 3. Check /opt/rollout.log exists and contains successful rollout status
if [[ ! -f /opt/rollout.log ]]; then
    echo -e "${RED}✗ File /opt/rollout.log not found${NC}"
    error=1
else
    # Look for common success messages from kubectl rollout status
    if ! grep -qiE "successfully rolled out|rollout complete|replicas.*up-to-date" /opt/rollout.log; then
        echo -e "${RED}✗ /opt/rollout.log does not contain a successful rollout status message${NC}"
        echo "   Expected something like: 'deployment \"web-deploy\" successfully rolled out'"
        error=1
    fi
fi

# Additional optional check: ensure rollout strategy is RollingUpdate (good practice)
strategy=$(kubectl get deployment web-deploy -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
if [[ "$strategy" != "RollingUpdate" ]]; then
    echo -e "${RED}✗ Deployment strategy should be RollingUpdate (recommended for this exercise)${NC}"
    error=1
fi

if [[ $error -eq 0 ]]; then
    echo -e "${GREEN}✓ All checks passed! You successfully scaled, watched, and logged the rollout.${NC}"
    exit 0
else
    echo -e "${RED}Some checks failed. Review the steps carefully.${NC}"
    exit 1
fi