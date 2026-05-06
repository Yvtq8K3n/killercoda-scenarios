
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

For this question, please set this context (In exam, diff cluster name)

`kubectl config use-context kubernetes-admin@kubernetes`{{exec}}

<br>

Create a Deployment named `web-deploy` with the following specifications:

- **Image:** `nginx:1.21`
- **Replicas:** 3
- **Container port:** 80
- **Rollout strategy:** RollingUpdate with `maxSurge=1` and `maxUnavailable=0`


Info:
- **Rolling Update:** Aims to prevent downtime by ensuring pods are updated gradually.
- **Max Surge:** In a given update, how many new pods can created at a time?
- **Max Unavailable:** In a given update, how many pods can be down?