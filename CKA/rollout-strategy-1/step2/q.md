
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

<br>

Perform the following actions on `web-deploy` deployment:
1. Check the Deployment rollout history
2. Scale the Deployment to **5 replicas**.
3. Wait for rollout to complete (use `k rollout status <command>`).
4. Save the rollout history of the Deployment to `/opt/rollout.log`

Question:
**Why is the rollout history unchanged and no Rolling Update was triggered?** 
- Rollout update is only triggerd during a application-level change