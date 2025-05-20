# Context

This incident is about a developer not being able to get a new pod running in production. This is caused by some unfortunate manual deletion of resources within the application earlier during the day which caused the PV to be stuck in `Terminating` state. New pods are unable to start because the application is unable to mount the PV, and because of rolling deployment the deployment isn't able to terminate the old pods, leading to a deadlock.

To show a nice example app, use https://argo.agis.d.tv2dev.dk/applications/agis-argocd/app

# Introduction

A colleague from Operations Center calls you to report, that a developer is unable to deploy a new version of their application during an important event. They will provide more details in a direct message (this is not a major incident).

# Prep

```bash
make incident-terminating-pvc
```

# Choices

## Slack

Ensure that the volunteer is a member of the `#dcp-wheel-of-misfortune` channel.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

Old pods are green, no hints in logs.

New pods are stuck in `Progressing` state.

Events of new pods:

```
Events:
  Type     Reason              Age                From                     Message
  ----     ------              ----               ----                     -------
  Normal   Scheduled           2s                 default-scheduler        Successfully assigned default/my-pod to node-1
  Warning  FailedMount         1s (x3 over 2s)    kubelet                  Unable to attach or mount volumes: unmounted volumes=[data], unattached volumes=[data kube-api-access-xxx]: timed out waiting for the condition
  Warning  FailedAttachVolume  1s (x2 over 2s)    attachdetach-controller  AttachVolume.Attach failed for volume "pvc-nfs" : volume is in terminating state
```

Description of PVC:

```
Name:          my-pvc
Namespace:     default
StorageClass:  standard
Status:        Terminating (finalizers pending)
Volume:        pvc-nfs
Finalizers:    [kubernetes.io/pvc-protection]
```

## Kubectl

### Applications

See "ArgoCD" section.

## Datadog

See "ArgoCD" section.

# Resolution

Volunteer resolves the deadlock. Easiest method is by just deleting the old pods. One could also delete the finalizer from the PVC, this should work but we should discuss afterwards if this method is used.
