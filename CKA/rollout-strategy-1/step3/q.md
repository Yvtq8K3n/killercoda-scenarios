
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

<br>

Change the `web-deploy` deployment with the following specifications:
1. Update the deployment to **image:** `nginx:1.22` (`k set` or `k edit`)
2. Watch the rollout progress (`k rollout status`).
3. Save the deployment rollout history to `/opt/rollout2.log`
