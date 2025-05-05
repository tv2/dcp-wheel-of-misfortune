# Context

This incident is about gateways being misconfigured because they don't allow scaling up enough. This means that the service in K8s is perfectly healthy and not under very much load, but all the while the Gateway pods are maxed out, the ALB sees a flood of timeouts, and the experience for customers is that play.tv2.dk sometimes responds, but often times it just slowly times out.

# Introduction

A colleague from Operations Center calls you to report, that customers experience that play.tv2.dk times out most of the time.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-play-is-timing-out
```

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

The application reports green in status, and health.

### Platform (gateways)

Ensure the volunteer can log into the ArgoCD UI.

The gateway application reports green in status and health.

## Kubectl

The gateway pods are maxed out in usage.

HPA reports unable to scale, limit has been hit.

Quotas are fine.

## Datadog

### Events

Events do not show anything in particular.

### Logs

Nothing in particular.

### Metrics

See what they find on their own. There is probably a metric.

## AWS Console

Viewing metrics for ALB in the AWS Console shows timeouts, 5xx, and so on.

# Resolution

See if they fix it.