targetScope = 'subscription'

param location string
param appName string
param environment string
param regions array
param identityApiVersions array
param inboxApiVersions array
param outboxApiVersions array
param profileApiVersions array
param aadOpenIdConfigUrl string
param aadOpenIdApimAudience string
param aadOpenIdIssuer string
param b2cOpenIdConfigUrl string
param b2cOpenIdAudience string
param b2cOpenIdIssuer string
param aadApisClientId string
param idHintTokenSigningCertificateThumbprint string
param idHintTokenIssuer string
param idHintTokenClientId string
param o365GraphTenantId string
param o365GraphClientId string
@secure()
param o365GraphClientSecret string
param o365GraphEmailSenderObjectId string
param identityApiLoadCertificateThumbprints string

var environmentName = '${appName}-${environment}'
var sharedResourceGroupName = toUpper('${environmentName}-SHARED')
var opsResourceGroupName = toUpper('${environmentName}-OPS')
var regionMap = {
	eastus: 'eus'
	westus: 'wus'
}

resource sharedResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
	name: sharedResourceGroupName
	location: location
}

resource opsResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
	name: opsResourceGroupName
	location: location
}

resource regionResourceGroups 'Microsoft.Resources/resourceGroups@2020-06-01' = [for region in regions: {
	name: toUpper('${environmentName}-${regionMap[region]}')
	location: region
}]

module opsDeployment 'ops.bicep' = {
	name: 'ops'
	dependsOn: [
		opsResourceGroup
	]
	scope: resourceGroup(opsResourceGroupName)
	params: {
		location: location
		environmentName: environmentName
	}
}

module sharedDeployment 'shared.bicep' = {
	name: 'shared'
	dependsOn: [
		sharedResourceGroup
	]
	scope: resourceGroup(sharedResourceGroupName)
	params: {
		location: location
		environmentName: environmentName
	}
}

module regionDeployments 'region.bicep' = [for region in regions: {
	name: region
	dependsOn: [
		opsDeployment
		regionResourceGroups
	]
	scope: resourceGroup(toUpper('${environmentName}-${regionMap[region]}'))
	params: {
		location: location
		environmentRegionName: '${environmentName}-${regionMap[region]}'
		sharedResourceGoupName: sharedResourceGroupName
		opsResourceGroupName: opsResourceGroupName
		cosmosDbName: sharedDeployment.outputs.cosmosDbName
		logAnalyticsName: opsDeployment.outputs.logAnalyticsName
		identityApiVersions: identityApiVersions
		inboxApiVersions: inboxApiVersions
		outboxApiVersions: outboxApiVersions
		profileApiVersions: profileApiVersions
		apimPublisherEmail: 'admin@openethos.io'
		apimPublisherName: 'OpenEthos'
		aadOpenIdConfigUrl: aadOpenIdConfigUrl
		aadOpenIdApimAudience: aadOpenIdApimAudience
		aadOpenIdIssuer: aadOpenIdIssuer
		b2cOpenIdConfigUrl: b2cOpenIdConfigUrl
		b2cOpenIdAudience: b2cOpenIdAudience
		b2cOpenIdIssuer: b2cOpenIdIssuer
		aadApisClientId: aadApisClientId
		idHintTokenSigningCertificateThumbprint: idHintTokenSigningCertificateThumbprint
		idHintTokenIssuer: idHintTokenIssuer
		idHintTokenClientId: idHintTokenClientId
		o365GraphTenantId: o365GraphTenantId
		o365GraphClientId: o365GraphClientId
		o365GraphClientSecret: o365GraphClientSecret
		o365GraphEmailSenderObjectId: o365GraphEmailSenderObjectId
		identityApiLoadCertificateThumbprints: identityApiLoadCertificateThumbprints
	}
}]
