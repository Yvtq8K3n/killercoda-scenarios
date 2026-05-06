
> <strong>Useful Resources</strong>: [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset//)

`kubectl config use-context kubernetes-admin@kubernetes`{{exec}}

<br>

The `lonely-wolf` is deployed, but only 2 replicas, why is pending?
Inst there a better thing? Instead of a deployment, change to daemonset :)


**Specifications:**
- Use the topology key: `kubernetes.io/hostname`
- Ensure the deployment can also be schedule on controlplane node

**Info:**
- By design controlplane nodes are tainted, what can be done to circumvent it?