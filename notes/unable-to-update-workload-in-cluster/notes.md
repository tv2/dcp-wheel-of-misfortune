# Context

This incident is about a product team's GitHub Actions workflow failing to deploy a critical update to their application running in an ECS cluster. They're asking for help with updating the ECS Task Definition image tag manually.
This incident is designed to test the volunteer's ability to say no to an incident which we shouldn't be handling.

# Introduction

A colleague from Operations Center calls you to report, that developers from a product team are requesting help from DCP.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-unable-to-update-workload-in-cluster
```

If the volunteer asks for which account the problem is in, the developer tells them it's the "app team" account.

# Resolution

The volunteer should report in the `#dcp-wheel-of-misfortune` channel, that DCP cannot help with this incident.