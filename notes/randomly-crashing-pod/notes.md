# Context
OC is calling, a team has problems with their application restarts randomly and it appears to be random

# Introduction
The pods are failing randomly and their logs doesn't tell them way. They need you to investigate why it's randomly crashing

# Prep
```
make incident-randomly-crashing-pod
```

# Choices

## Datadog
See graphs for memory usage, see they hit limit
https://app.datadoghq.eu/metric/explorer?fromUser=false&graph_layout=stacked&start=1768828839641&end=1768832439641&paused=false#N4Ig7glgJg5gpgFxALlAGwIYE8D2BXJVEADxQEYAaELcqyKBAC1pEbghkcLIF8qo4AMwgA7CAgg4RKUAiwAHOChASAtnADOcAE4RNIKtrgBHPJoQaUAbVBGN8qVoD6gnNtUZCKiOq279VKY6epbINiAiGOrKQdpYZAYgUJ4YThr42gDGSsgg6gi6mZaBZnHKGABuMMgA1ngARjoiiJoAdOqqbliteBoY8E7ymQjAcCIVyAIVFAAEmWi9CDrI84s6ALQA7LN1jU6RvvIY2StF62A4qoLrAAw3AMw8IDwAulSu7niYoeEfql8YGKleLPN4gDRyNA5UBHKEIJbKKA4GBOeYYDQaCCZRJoURwJxyRTKdK4qA4vFOehMZQiNweNDPfgQeyYLAEhQ5EC45qgnh8cHyXEIADCUmEMBQIi+aB4QA

## ArgoCD
might see crash-backoff


## Kubectl