# Context

This incident is about a new application that unfortunately floods the K8s DNS server with requests due to a bug in the code. This causes the DNS server to become unresponsive and thus all applications that rely on DNS resolution fail to load.

# Introduction

A colleague from Operations Center calls you to report, that developers from many different product teams are experiencing issues with their critical applications.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-hostname-unresolvable
```

Once the volunteer has acknowledged the incident, ask if they are in the channel "#ccp-datadog-alerts". If they are a member, tell them that this alarm has been triggered in that channel: https://tv2.slack.com/archives/C06C8UAQ3F0/p1747998171361049.

If the Slack message is not available, or the Datadog alert/graphs are have been deleted, make use of the screenshot in the `notes/hostname-unresolvable/` directory.

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

## ArgoCD

### Application

Ensure the volunteer can log into the ArgoCD UI.

The application is degraded. If they look they will see one of the following:

#### Java
```
2025-06-03 10:31:17,942 ERROR com.example.service.Client - Failed to resolve host: my-db.default.svc.cluster.local
java.net.UnknownHostException: my-db.default.svc.cluster.local
    at java.base/java.net.InetAddress$CachedAddresses.get(InetAddress.java:797)
    at java.base/java.net.InetAddress.getAllByName0(InetAddress.java:1534)
    at java.base/java.net.InetAddress.getAllByName(InetAddress.java:1411)
    at java.base/java.net.InetAddress.getByName(InetAddress.java:1361)
```

#### Go
```
2025/06/03 10:33:42 http: error making request to "http://user-service.default.svc.cluster.local/api/login": dial tcp: lookup user-service.default.svc.cluster.local on 10.96.0.10:53: no such host
```

#### Node
```
[2025-06-03T10:35:25.452Z] ERROR: api-server/1252 on app-pod-12345: request to auth.default.svc.cluster.local failed
Error: getaddrinfo ENOTFOUND auth.default.svc.cluster.local
    at GetAddrInfoReqWrap.onlookup [as oncomplete] (dns.js:67:26)
```

## Kubectl

See "ArgoCD" section.

## Datadog

### Events

Events do not show anything in particular.

### Logs

See "ArgoCD" section.

# Resolution

The volunteer should make use of Datadog to identify the problem. They should find that the application is reporting many nxdomain errors once they get the correct metric using the alarm definition. They should then be able to use Datadog to find a correlation between the CoreDNS errors and a pod which attempts many connections to form similar spikes in graphs.

With this knowledge, the volunteer should be able to identify the application and team that is causing the issue. With a bit of communication in the Slack channel, the offending product team will immediately kill the problematic pod. Shortly after operations will return to normal.