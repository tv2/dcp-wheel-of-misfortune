# Context

This incidents is about a quota being hit, which prevents a service from scaling sufficiently, thereby bringing down the subscription capability.

# Introduction

A colleague from Operations Center calls you to report, that customers are unable to submit orders for new subscriptions.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-failing-payments
```

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

## ArgoCD

Ensure the volunteer can log into the ArgoCD UI.

The application reports green in status, but health seems to be stuck in `Progressing` state.

Inside the Argo app in the UI, the ReplicaSet seems to be degraded.

If investigating the `ReplicaSet` Kubernetes manifest, it contains this:

```yaml
...
status:
  availableReplicas: 13
  conditions:
  - lastTransitionTime: "2025-05-02T11:22:47Z"
    message: 'pods "subscription-86689bbc79-rg2r2" is forbidden: exceeded quota: subscription-quota,
      requested: pods=26, used: pods=20, limited: pods=20'
    reason: FailedCreate
    status: "True"
    type: ReplicaFailure
  fullyLabeledReplicas: 13
  observedGeneration: 8
  readyReplicas: 13
  replicas: 13
```

If opening the `Events` tab, the volunteer will see ![alt text](/notes/failing-payments/argo-rs-events.png "Title")

## Kubectl

Is investigating the `ReplicaSet` Kubernetes manifest, it contains this:

```yaml
...
status:
  availableReplicas: 13
  conditions:
  - lastTransitionTime: "2025-05-02T11:22:47Z"
    message: 'pods "subscription-86689bbc79-rg2r2" is forbidden: exceeded quota: subscription-quota,
      requested: pods=26, used: pods=20, limited: pods=20'
    reason: FailedCreate
    status: "True"
    type: ReplicaFailure
  fullyLabeledReplicas: 13
  observedGeneration: 8
  readyReplicas: 13
  replicas: 13
```

## Datadog

### Events

The volunteer finds this: `24 FailedCreate: (combined from similar events): Error creating: pods "subscription-6db967cb59-h8dzx" is forbidden: exceeded quota: subscription-quota, requested: pods=26, used: pods=20, limited: pods=20`

### Logs

Nothing in particular.

### Metrics

See what they find on their own. There is probably a metric.

# Resolution

See if they fix it.