# Context

This incident is about all web applications of a tenant failing to load. The cause of this is that tenants have accidentally deleted the IAM role for the External DNS component. This has left external-dns unable to update the DNS records to point to the new DNS name of their Load Balancer (load balancer shouldn't get new DNS names but in this case it did).

# Introduction

A colleague from Operations Center calls you to report, that the critical applications of a product team are unable to load.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-tenant-applications-never-load
```

Also make sure to post this: ![alt text](/notes/tenant-applications-never-load/connection-timed-out.png "Title")

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

The application reports green in status.

### Platform - Tenant External DNS

Logs show the following error:

```
2025-05-20T13:04:12.489Z [ERROR] [external-dns-65d4c7b9d4-qxk7j] Failed to assume IAM role: arn:aws:iam::183631338653:role/ccs-pvp-external-dns
2025-05-20T13:04:12.489Z [DEBUG] [external-dns-65d4c7b9d4-qxk7j] Using AWS SDK version 1.11.118
2025-05-20T13:04:12.490Z [INFO]  [external-dns-65d4c7b9d4-qxk7j] Attempting to assume role with web identity token from /var/run/secrets/eks.amazonaws.com/serviceaccount/token
2025-05-20T13:04:12.652Z [ERROR] [external-dns-65d4c7b9d4-qxk7j] STS AssumeRole call failed with error: AccessDenied: Not authorized to perform sts:AssumeRole on resource ccs-pvp-external-dns.
	status code: 404, request id: 3b4f30e0-92a0-4a6e-a748-95e9c2cf52df
2025-05-20T13:04:12.653Z [WARN]  [external-dns-65d4c7b9d4-qxk7j] Retrying in 30s...
```

## Kubectl

See "ArgoCD" section.

## Datadog

### Events

Events do not show anything in particular.

### Logs

See "ArgoCD" section.

# Resolution

Inform the developer that it is their responsibility to create the IAM role. DCP do not have permissions to do this for them.
If the volunteer is fast then make the developer ask them to help them find to Terraform code to accomplish this.