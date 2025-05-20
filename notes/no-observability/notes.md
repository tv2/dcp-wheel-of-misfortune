# Context

This incident is about a developer not being able to observe their application during an important event. Operations Center is contacting DCP to request their help, and to inform them that the developer will contact them directly.

# Introduction

A colleague from Operations Center calls you to report, that a developer is unable to observe their application during an important event. They will provide more details in a direct message (this is not a major incident).

# Prep

```bash
make incident-no-observability
```

# Choices

## Slack

Ensure that the volunteer is a member of the `#dcp-wheel-of-misfortune` channel.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

Datadog application is green. It's logs show the following error about an invalid api key

```
2023-10-05 14:32:10 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:10 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:10 UTC | WARN  | (retry.go:112 in retry) | Retrying in 10s (attempt 1/5)...
2023-10-05 14:32:20 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:20 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:20 UTC | WARN  | (retry.go:112 in retry) | Retrying in 20s (attempt 2/5)...
2023-10-05 14:32:40 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:40 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:40 UTC | WARN  | (retry.go:112 in retry) | Retrying in 40s (attempt 3/5)...
```

## Kubectl

### Applications

Datadog agent logs:

```
2023-10-05 14:32:10 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:10 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:10 UTC | WARN  | (retry.go:112 in retry) | Retrying in 10s (attempt 1/5)...
2023-10-05 14:32:20 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:20 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:20 UTC | WARN  | (retry.go:112 in retry) | Retrying in 20s (attempt 2/5)...
2023-10-05 14:32:40 UTC | ERROR | (api.go:345 in process) | Error submitting metrics to Datadog: HTTP 403 Forbidden
2023-10-05 14:32:40 UTC | ERROR | (api.go:346 in process) | Response: {"errors": ["API key is invalid"]}
2023-10-05 14:32:40 UTC | WARN  | (retry.go:112 in retry) | Retrying in 40s (attempt 3/5)...
```

## Datadog

Datadog works. Other envs are not affected. No metrics or logs seem to be coming from the cluster.

# Resolution

Volunteer should generate a new API key, save it in the AWS Secret Manager and then restart the Datadog agent.
