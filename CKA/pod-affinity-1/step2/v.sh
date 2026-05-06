#!/bin/bash

# Check if deployment exists
if ! kubectl get deployment web-deploy &>/dev/null; then
    echo -e "${RED}✗ Deployment 'web-deploy' not found${NC}"
    exit 1
fi

# 1. Check initial replicas and strategy
replicas=$(kubectl get deployment web-deploy -o jsonpath='{.spec.replicas}')
strategy=$(kubectl get deployment web-deploy -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
maxUnavail=$(kubectl get deployment web-deploy -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
image=$(kubectl get deployment web-deploy -o jsonpath='{.spec.template.spec.containers[0].image}')

if [[ "$replicas" != "3" ]]; then
    echo -e "${RED}✗ Initial replicas should be 3, found $replicas${NC}"
    error=1
fi

if [[ "$strategy" != "1" ]]; then
    echo -e "${RED}✗ maxSurge should be 1, found $strategy${NC}"
    exit 1
fi

if [[ "$maxUnavail" != "0" ]]; then
    echo -e "${RED}✗ maxUnavailable should be 0, found $maxUnavail${NC}"
    exit 1
fi

if [[ "$image" != "nginx:1.21" ]]; then
    echo -e "${RED}✗ Initial image should be nginx:1.21, found $image${NC}"
    exit 1
fi

exit 0