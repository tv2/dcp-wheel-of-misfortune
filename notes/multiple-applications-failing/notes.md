# Context

This incident is about multiple product team applications being unable to scale due to being stuck in pending. This issue arises because Karpenter is failing to add new nodes to the cluster.

# Introduction

A colleague from Operations Center calls you to report, that several product teams report their critical applications are unable to scale.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-multiple-applications-failing
```

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

The application reports green in status, but health is stuck in `Progressing` state.

If clicking on a pod unable to scale this message is shown:

```
1 FailedScheduling: 0/22 nodes are available: 1 Insufficient cpu, 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }, 10 node(s) didn't match Pod's node affinity/selector, 3 node(s) had untolerated taint {CriticalAddonsOnly: true}, 7 node(s) had untolerated taint {karpenter.sh/disrupted: }. 1 FailedScheduling: 0/22 nodes are available: 1 Insufficient cpu, 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }, 10 node(s) didn't match Pod's node affinity/selector, 3 node(s) had untolerated taint {CriticalAddonsOnly: true}, 7 node(s) had untolerated taint {karpenter.sh/disrupted: }. preemption: not eligible due to a terminating pod on the nominated node.
```

## Kubectl

### Applications

In events they report:

```
1 FailedScheduling: 0/22 nodes are available: 1 Insufficient cpu, 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }, 10 node(s) didn't match Pod's node affinity/selector, 3 node(s) had untolerated taint {CriticalAddonsOnly: true}, 7 node(s) had untolerated taint {karpenter.sh/disrupted: }. 1 FailedScheduling: 0/22 nodes are available: 1 Insufficient cpu, 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }, 10 node(s) didn't match Pod's node affinity/selector, 3 node(s) had untolerated taint {CriticalAddonsOnly: true}, 7 node(s) had untolerated taint {karpenter.sh/disrupted: }. preemption: not eligible due to a terminating pod on the nominated node.
```

### Karpenter

Under logs, the following error is shown:

```
error validating NodePool "bottlerocket-amd64". NodePool spec is invalid.
```

After seeing this, the volunteer remembers that a colleague posted about a recent Karpenter upgrade that was deployed.

## Datadog

### Events

Events do not show anything in particular.

### Logs

Karpenter logs show the following error:

```
error validating NodePool "bottlerocket-amd64". NodePool spec is invalid.
```

# Resolution

See if they fix it.