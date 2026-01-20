# Context

A tenant asks for a new application loadballancer as they need to expose their web application to on-prem storage.
They don't care about the domain

# Introduction

A developer asks for a new loadballancer for their application in dev. They are CCS-tenant
Link to Argocd application:
https://argo.ccs.d.tv2dev.dk/applications/ccs-argocd/womf-incident-002-nginx?view=tree&resource=

# Prep

```
make create-new-loadbalancer
```

# Resolution:

1. Go to tv2/ccs-cloud-infrastructure
2. Add loadbalancer to configuration
3. Either create PR and plan/apply with project "ccs-dev-116172753206-infra-aws-account-common-tenants" or run following commands locally:

```
make ccs-dev-116172753206/infra/aws-account-common/tenants-init
make ccs-dev-116172753206/infra/aws-account-common/tenants-plan
make ccs-dev-116172753206/infra/aws-account-common/tenants-apply
```

4. go to tv2/ccs-infrastructure-bootstrap
5. Create PR with new LB config in `config/tenants/ccs/dev/ccs-dev.yaml`
6. Get PR approved, then merged

7. Run `make ...update-pr`

```
TENANTS=ccs make -C ccs-dev-116172753206-cfg/cluster-7/ component-gateways-update-pr
```

8. Merge PR
9. Verify gateway has been created in argocd
10. Ask the developers to add hosts configuration to their application in tv2/ccs-gitops-config
