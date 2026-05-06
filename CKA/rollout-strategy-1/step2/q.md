
> <strong>Useful Resources</strong>: [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

<br>

Perform the following actions over the `web-deploy` deployment:
1. Check the deployment rollout history
2. Scale the Deployment to **5 replicas**.
3. Wait for rollout to complete (use `kubectl rollout <command>`).
4. Save the rollout history of the Deployment to `/opt/rollout.log`

Question:
**Why Rolling Update was not triggerd?** 
- Rollout update is triggerd during a application-level change