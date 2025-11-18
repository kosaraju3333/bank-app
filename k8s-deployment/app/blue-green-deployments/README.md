Install ArgoC
Kubernetes Strategies:
Step 1:
-  First we have to Install Argo Rollouts Controller and Argo Rollout Plugin
	- Argo Rollout Controller
		- kubectl create namespace argo-rollouts
		- kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

	- Argo Rollout Plugin
```bash
		- curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
		- chmod +x ./kubectl-argo-rollouts-linux-amd64
		- sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
		- kubectl argo rollouts version
```
Step 2:
- Create rollout object and all required resources

Argo rollout commands:
```bash
- kubectl argo rollouts get rollout rollouts-name --watch
	- eg: kubectl argo rollouts get rollout portal-app-rollout -n portal-app
- kubectl get ro -n portal-app
- kubectl argo rollouts promote portal-app-rollout -n portal-app
- kubectl argo rollouts abort rollouts-demo
```
