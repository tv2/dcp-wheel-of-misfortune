# Context
This incident is about debugging why a tenant has built a new version of their image, but it's not deployed to the cluster. The Application in ArgoCD is failing. The issue is, the tenant is not using Pixel but has _manually_ changed the image tag to a wrong value, causing kubernetes to fail downloading the new version.

# Introduction
A colleague from Operations Center calls you to report an incident is going on and that some team needs to release a new version of their application _NOW_. Unfortuanetly it's a recently hired developer who is trying to fix it and since its a very new application they haven't configured Pixl yet, so they are just manually changing the image tag in the yaml file.

# Prep
make incident-cant-pull-image-after-update

# Choices
## kubectl
Shows pod is failing to start
## argocd
Sees application is failing and the new nersion of the pod is failing