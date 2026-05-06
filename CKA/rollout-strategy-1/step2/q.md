
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

<br>

Update the `web-deploy` deployment:
1. Scale the Deployment to **5 replicas**.
2. Wait for rollout to complete (use `kubectl <command> --watch`).
3. Save the final rollout status to `/opt/rollout.log`