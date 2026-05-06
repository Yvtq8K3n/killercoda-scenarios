
> <strong>Useful Resources</strong>: [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

For this question, please set this context (In exam, diff cluster name)

`kubectl config use-context kubernetes-admin@kubernetes`{{exec}}

<br>

Create a Deployment named `web-deploy` with the following specifications:

- **Replicas:** 3
- **Image:** `nginx:1.21`
- **Rollout strategy:** RollingUpdate with `maxSurge=1` and `maxUnavailable=0`
- **Container port:** 80