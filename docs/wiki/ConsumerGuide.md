<!-- markdownlint-disable MD041 -->
## Consumer Guide

## Background

This repository has been created to help customers and partners to create, deploy and deliver landing zone Subscriptions into an Microsoft Entra Tenant utilizing [Bicep](https://aka.ms/bicep) as the Infrastructure-as-Code (IaC) tooling and language of choice.

## Ways to Consume `bicep-lz-vending`

### Recommended Way to Consume

The recommend way is to consume the module directly from the [Bicep public registry](https://aka.ms/lz-vending/bicep)

```bicep
targetScope = 'managementGroup'

module sub001 'br/public:avm/ptn/lz/sub-vending:0.1.0' = {
  name: 'sub001'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-001'
    subscriptionDisplayName: 'sub-test-001'
    subscriptionTags: {
      example: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    // Other parameter inputs available, see docs
  }
}
```

### Other Ways to Consume

There are a number of other ways to consume the Bicep modules included in `bicep-lz-vending`. The options are:

- Clone [this repository](https://aka.ms/brm)
- Fork & Clone [this repository](https://aka.ms/brm)
- Download a `.zip` copy of [this repo](https://aka.ms/brm)
- Upload a copy of the locally cloned/downloaded modules to your own:
  - Git Repository
  - Private Bicep Module Registry
    - See:
      - [Create private registry for Bicep modules](https://docs.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry)
  - Template Specs
    - See:
      - [Azure Resource Manager template specs in Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/template-specs)

The option to use will be different per consumer based on their experience and skill levels with the various pieces of technology and their features.
