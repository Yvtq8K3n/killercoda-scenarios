
> <strong>Useful Resources</strong>: [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset//)

<br>

The `lonely-wolf` Deployment is running, but due anti‑affinity one pod is in `Pending` state.  
To ensure "one pod per node" and long term maintainability change it to a **DaemonSet**.

**Specifications:**
- Delete the `lonely-wolf` Deployment
- Create a DaemonSet named `lonely-wolf`
- Run on **all** nodes (including controlplane)

**Info:**
- By design controlplane nodes are tainted, what can be done to circumvent it?

**Verification:**  
`kubectl get pods -o wide` – one running pod on each node, zero `Pending`.