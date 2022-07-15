targetScope = 'managementGroup'

// PARAMETERS

// Subscription Parameters
@description(' Whether to create a new subscription using the subscription alias resource. If disabled, supply the existingSubscriptionId parameter instead.')
param subscriptionAliasEnabled bool = true

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.')
param subscriptionDisplayName string

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, -, _ and space. The maximum length is 63 characters.')
param subscriptionAliasName string

@description('The billing scope for the new subscription alias. A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.')
param subscriptionBillingScope string

@allowed([
  'DevTest'
  'Production'
])
@description('The workload type can be either `Production` or `DevTest` and is case sensitive.')
param subscriptionWorkload string = 'Production'

@maxLength(36)
@description('An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.')
param exisitingSubscriptionId string = ''

// Subscription Resources Wrapper Parameters

param subscriptionTags object = {}

param virtualNetworkTags object = {}

param virtualNetworkResourceGroupName string = ''

param virtualNetworkEnabled bool = true

param virtualNetworkLocation string = deployment().location

// VARIABLES

var existingSubscriptionIDEmptyCheck = empty(exisitingSubscriptionId) ? 'No Subscription ID Provided' : exisitingSubscriptionId

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createSubscription: take('lz-vend-sub-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload)}', 64)
  createSubscriptionResources: take('lz-vend-sub-res-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload)}', 64)
}

// RESOURCES & MODULES

module createSubscription 'src/self/Microsoft.Subscription/aliases/deploy.bicep' = if (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) {
  scope: tenant()
  name: deploymentNames.createSubscription
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: subscriptionAliasName
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionWorkload: subscriptionWorkload
  }
}

module createSubscriptionResources 'src/self/subResourceWrapper/deploy.bicep' = if ((subscriptionAliasEnabled || !empty(exisitingSubscriptionId)) && virtualNetworkEnabled && !empty(virtualNetworkResourceGroupName)) {
  name: deploymentNames.createSubscriptionResources
  params: {
    subscriptionId: (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionId : exisitingSubscriptionId
    virtualNetworkEnabled: virtualNetworkEnabled
    virtualNetworkLocation: virtualNetworkLocation
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    subscriptionTags: subscriptionTags
    virtualNetworkTags: virtualNetworkTags
  }
}

// OUTPUTS

output subscriptionId string = (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '${exisitingSubscriptionId}'
output subscriptionResourceId string = (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionResourceId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '/subscriptions/${exisitingSubscriptionId}'
