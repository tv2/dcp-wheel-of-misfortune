# Context
A tenant's application cannot start after they migrated their infrastructure to another AWS account. The developer is pretty sure he has created all resources but his API is answering with status 500.
The problem is the developer has forgotten to change the AccountID in the SA's role.

# Introduction
The application cannot start after the AWS resources has been migrated to a new AWS Account. Everything should be in place.


Engineer needs to figure out on his own that the secret is missing in the new aws account and it's causing the application to fail.

# Prep
```
make missing-secrets
```


# Resolution
Change role ARN to the new account