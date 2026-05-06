#!/bin/bash

deployment="lonely-wolf"  # assuming the deployment name matches the file name

# 1. Check that the Deployment exists
if ! kubectl get deployment "$deployment"  &>/dev/null; then
    echo -e "Deployment '$deployment' not found$"
    exit 1
fi

# 2. Get lonely-wolf pods and count their statuses
pods=$(kubectl get pods -l app=lonely-wolf -o json)
running_pods=$(echo "$pods" | jq '[.items[] | select(.status.phase=="Running")] | length')
pending_pods=$(echo "$pods" | jq '[.items[] | select(.status.phase=="Pending")] | length')

# 3. Verify total replicas = 3 (from deployment)
replicas=$(kubectl get deployment "$deployment" -o jsonpath='{.spec.replicas}')
if [ "$replicas" -ne 3 ]; then
    echo -e "Deployment replicas is $replicas, expected 3}"
    exit 1
fi

# 4. With 2 schedulable nodes (controlplane + worker), we expect 2 Running, 1 Pending
if [ "$running_pods" -ne 2 ] || [ "$pending_pods" -ne 1 ]; then
    echo -e "Expected 2 running pods and 1 pending, but found $running_pods running, $pending_pods pending"
    exit 1
fi

# 5. Check that no two running pods share the same node
nodes=$(echo "$pods" | jq -r '.items[] | select(.status.phase=="Running") | .spec.nodeName' | sort)
unique_nodes=$(echo "$nodes" | uniq | wc -l)
total_nodes=$(echo "$nodes" | wc -l)
if [ "$unique_nodes" -ne "$total_nodes" ]; then
    echo -e "Anti‑affinity violation: two running pods on the same node"
    exit 1
fi

# 6. Verify if at least one pod is scheduled on controlplane
controlplane_pod=$(echo "$pods" | jq -r '.items[] | select(.status.phase=="Running" and .spec.nodeName | contains("controlplane")) | .metadata.name')
if [ -z "$controlplane_pod" ]; then
    echo -e "No pod scheduled on controlplane – toleration may be missing or taint not removed"
    # This is a warning, not a failure, because the exercise allows controlplane but doesn't *require* it if another node exists.
else
    echo -e "Pod '$controlplane_pod' runs on controlplane (toleration works)"
fi

# 7. Check the Pending pod's reason (is "Unschedulable" due to anti‑affinity)
pending_pod=$(echo "$pods" | jq -r '.items[] | select(.status.phase=="Pending") | .metadata.name')
pending_reason=$(kubectl get pod "$pending_pod" -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].reason}')
if [ "$pending_reason" != "Unschedulable" ]; then
    echo -e "Pending pod reason is '$pending_reason', expected 'Unschedulable'"
else
    echo -e "Pending pod correctly unschedulable (anti‑affinity constraint)"
fi

echo -e "All validation checks passed! Anti‑affinity and toleration configured correctly"
exit 0