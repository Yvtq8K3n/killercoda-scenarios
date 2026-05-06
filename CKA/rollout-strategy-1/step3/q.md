
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

<br>

Change the `web-deploy` deployment with the following specifications:
1. Update the deployment to **image:** `nginx:1.22` (use `kubectl set` or manually edit deployment)
1. Watch the rollout progress (use `kubectl rollout status`).
2. Save the rollout history of the Deployment to `/opt/rollout2.log`
