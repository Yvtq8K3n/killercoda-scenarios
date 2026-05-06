#!/bin/bash

# Expected image and command
expected_image="nginx"
expected_version="1.22"

current_image=$(kubectl get deployment web-deploy -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$current_image" != "${expected_image}:${expected_version}" ]]; then
    echo -e "${RED}✗ Image should be ${expected_image}:${expected_version}, found $current_image${NC}"
    exit 1
fi
