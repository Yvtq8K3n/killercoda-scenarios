> <strong>Useful Resources</strong>: [Affinity & Anti‑affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) | [Taints & Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)

`kubectl config use-context kubernetes-admin@kubernetes`{{exec}}

<br>

Modify the deployment `lonely-wolf.yaml` to ensure there is **only one pod per node**.

**Specifications:**
- Use the topology key: `kubernetes.io/hostname`
- Ensure the deployment can also be schedule on controlplane node

**Info:**
- By design controlplane nodes are tainted, what can be done to circumvent it?