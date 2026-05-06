#!/bin/bash

# 1. Check that the Deployment is gone (optional, but good)
if kubectl get deployment lonely-wolf &>/dev/null; then
    echo -e "Deployment 'lonely-wolf' still exists"
    exit 1
fi

# 2. Check DaemonSet exists
if ! kubectl get daemonset lonely-wolf &>/dev/null; then
    echo -e "DaemonSet 'lonely-wolf' not found"
    exit 1
fi

# 3. Check image (should be nginx:latest or just nginx)
image=$(kubectl get daemonset lonely-wolf -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$image" != "nginx"* ]]; then
    echo -e "Image is '$image', expected nginx:latest or similar"
    exit 1
fi

# 4. Check toleration for controlplane
toleration=$(kubectl get daemonset lonely-wolf -o jsonpath='{.spec.template.spec.tolerations}')
if [[ -z "$toleration" ]]; then
    echo -e "No tolerations found – DaemonSet will not schedule on controlplane"
    exit 1
fi

# Check for controlplane key (either exact key or existence operator)
if echo "$toleration" | grep -qi "control-plane"; then
    echo -e "Toleration for controlplane present"
else
    echo -e "Toleration for controlplane not found"
    exit 1
fi

# 5. Check pods: one per node, all running
nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
node_count=$(echo "$nodes" | wc -w)

# Get pods from DaemonSet
pods=$(kubectl get pods -l app=lonely-wolf -o json)  # assuming label matches; fallback to owner reference
if [ -z "$(echo "$pods" | jq '.items[0]')" ]; then
    # Try fallback: get pods owned by DaemonSet
    pods=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.ownerReferences[]?.name=="lonely-wolf")')
fi

running_pods=$(echo "$pods" | jq -r 'select(.status.phase=="Running")' | jq -s 'length')
pending_pods=$(echo "$pods" | jq -r 'select(.status.phase=="Pending")' | jq -s 'length')

if [ "$running_pods" -ne "$node_count" ]; then
    echo -e "Expected $node_count running pods (one per node), but found $running_pods running"
    exit 1
fi
echo -e "$running_pods pods running (one per node)"

if [ "$pending_pods" -ne 0 ]; then
    echo -e "$pending_pods pod(s) pending – anti‑affinity may still be present or node issues"
    exit 1
else
    echo -e "No pending pods"
fi

# Optional: verify each pod is on a distinct node (DaemonSet guarantees it, but check anyway)
pod_nodes=$(echo "$pods" | jq -r '.spec.nodeName' | sort | uniq)
if [ $(echo "$pod_nodes" | wc -l) -eq "$node_count" ]; then
    echo -e "Pods are distributed one per node"
else
    echo -e "Pods not one per node – DaemonSet misconfigured"
    exit 1
fi

echo -e "All checks passed! DaemonSet is correctly configured."
exit 0