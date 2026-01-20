# Context
This incident is about debugging why a tenant's image has not been updated after re-building their image. The Application in ArgoCD is failing. The issue is, the tenant is not using Pixel but has _manually_ changed the image tag to a wrong value, causing kubernetes to fail downloading the new version.

# Prep
make incident-cant-pull-image-after-update

# Choices
## kubectl
Shows pod is failing to start
## argocd
Sees application is failing and the new version of the pod is failing