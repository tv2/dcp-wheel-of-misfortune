# Context

This incident is about a team whose WAF ruleset contains a rate limit, which has turned out to be too restrictive. The team doesn't know how they should modify it, so they ask for help.

# Introduction

A colleague from Operations Center calls you to report, that customers experience issues getting access to content.

A thread is running in `#major_incident` in Slack

# Prep

```bash
make incident-waf-rate-limit
```

# Choices

## Slack

Ensure that the volunteer is a member of `#major_incident` and `#dcp-wheel-of-misfortune` channels.

# Resolution

See if they fix it.