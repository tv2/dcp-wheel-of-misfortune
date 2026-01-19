# Context
OC is calling, a team has problems with their application restarts randomly and it appears to be related to the amount of incoming traffic.  

# Introduction
The pods are failing randomly and their logs doesn't tell them way. They need you to investigate why it's randomly crashing

# Prep
```
make incident-randomly-crashing-pod
```

# Choices

## Datadog
See graphs for memory usage, see they hit limit

## ArgoCD
might see crash-backoff


## Kubectl