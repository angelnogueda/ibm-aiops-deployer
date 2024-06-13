# ****************************************************************************************************************************************************
# ****************************************************************************************************************************************************
# Custom Scenarios
# ****************************************************************************************************************************************************
# ****************************************************************************************************************************************************
#
# See here: https://github.com/niklaushirt/ibm-aiops-deployer?tab=readme-ov-file#6-custom-scenarios
#
# ****************************************************************************************************************************************************
# 🚀 USAGE
#
#  STEP 1: Initializaion of Customization
#          Loads cusotm Topology and sets the custom properties to OK
#
#          Run ./1_customize-init.sh
#
#
#  STEP 2: Create Custom Incident
#          Injects Events and sets the custom properties to NOK
#
#          Run ./2_create-incident.sh
#
#
#  STEP 3: Clear Custom Incident
#          Clears Alerts and Incidents and sets the custom properties back to OK
#
#          Run ./3_clear-incident.sh
#
#






# ----------------------------------------------------------------------------------------------------------------------------------------------------
# Custom Topology
# ----------------------------------------------------------------------------------------------------------------------------------------------------
#
# See here: https://www.ibm.com/docs/en/cloud-paks/cloud-pak-aiops/4.5.1?topic=jobs-file-observer
#
#
# To create a complete Topology/Application, you have to define the following variables:
# 
#   - `CUSTOM_TOPOLOGY_APP_NAME` : Name for the Application (if this is left empty, no Application is created)
#   - `CUSTOM_TOPOLOGY_TAG` : Tag used to create the Topology Template (if this is left empty, no Template is created)
#   - `CUSTOM_TOPOLOGY`: Topology definition, will be loaded through a File Explorer (make sure that you have a corresponding tag to create the Template)
#

export CUSTOM_TOPOLOGY_APP_NAME='Custom Demo Application'

export CUSTOM_TOPOLOGY_TAG='app:custom-app'

export CUSTOM_TOPOLOGY='V:{"uniqueId": "test01-id", "name": "Deployment1", "entityTypes": ["deployment"], "tags":["tag1","app:custom-app"],"matchTokens":["test01","test01-id"],"mergeTokens":["test01","test01-id"], "city":"Richmond", "area": "Broad Meadows", "geolocation": { "geometry": { "coordinates": [-77.56121810464228, 37.64360674606608],"type": "Point"}},"_operation": "InsertUpdate", "app":"test", "fromFile":"true", "_references": [{"_toUniqueId":"test02-id","_edgeType":"connectedTo"},{"_toUniqueId":"test03-id","_edgeType":"connectedTo"}]}
V:{"uniqueId": "test02-id", "name": "VM1", "entityTypes": ["vm"], "tags":["tag1","app:custom-app"],"matchTokens":["test02","test02-id"],"mergeTokens":["test02","test02-id"], "city":"Richmond", "area": "Broad Meadows", "geolocation": { "geometry": { "coordinates": [-77.56121810464228, 37.64360674606608],"type": "Point"}},"_operation": "InsertUpdate", "app":"test", "fromFile":"true", "_references": [{"_toUniqueId":"test03-id","_edgeType":"connectedTo"}]}
V:{"uniqueId": "test03-id", "name": "Database1", "entityTypes": ["database"], "tags":["tag1","app:custom-app"],"matchTokens":["test03","test03-id"],"mergeTokens":["test03","test03-id"], "city":"Richmond", "area": "Broad Meadows", "geolocation": { "geometry": { "coordinates": [-77.56121810464228, 37.64360674606608],"type": "Point"}},"_operation": "InsertUpdate", "app":"test", "fromFile":"true", "_references": []}
'





# ----------------------------------------------------------------------------------------------------------------------------------------------------
# Custom Events
# ----------------------------------------------------------------------------------------------------------------------------------------------------
# Inject Events to simulate the Custom Scenario.
# 
#   - `CUSTOM_EVENTS` : List of Events to be injected sequentially (order is being respected)
# 
# 
# 🛠️ Format
# 
# {
# 	"id": "1a2a6787-59ad-4acd-bd0d-000000000000",    <-- Optional
# 	"occurrenceTime": "MY_TIMESTAMP",                <-- Do not modify
# 	"summary": "Summary - Problem test01",           <-- The text of the event
# 	"severity": 6,
# 	"expirySeconds": 6000000,
# 	"links": [{
# 		"linkType": "webpage",
# 		"name": "LinkName",
# 		"description": "LinkDescription",
# 		"url": "https://ibm.com/index.html"
# 	}],
# 	"sender": {
# 		"type": "host",
# 		"name": "SenderName",
# 		"sourceId": "SenderSource"
# 	},
# 	"resource": {
# 		"type": "host",
# 		"name": "test01",                            <-- This is the resource name that will be matched to Topology (see MatchTokens)
# 		"sourceId": "ResourceSorce"
# 	},
# 	"details": {
# 		"Tag1Name": "Tag1",
# 		"Tag2Name": "Tag2"
# 	},
# 		"type": {
# 		"eventType": "problem",
# 		"classification": "EventType"
# 	}
# }
#

export CUSTOM_EVENTS='{ "id": "1a2a6787-59ad-4acd-bd0d-000000000000", "occurrenceTime": "MY_TIMESTAMP", "summary": "Summary - Problem test01", "severity": 6, "type": { "eventType": "problem", "classification": "EventType" }, "expirySeconds": 6000000, "links": [ { "linkType": "webpage", "name": "LinkName", "description": "LinkDescription", "url": "https://pirsoscom.github.io/git-commit-mysql-vm.html" } ], "sender": { "type": "host", "name": "SenderName", "sourceId": "SenderSource" }, "resource": { "type": "host", "name": "test01", "sourceId": "ResourceSorce" }, "details": { "Tag1Name": "Tag1", "Tag2Name": "Tag2" }}
{ "id": "1a2a6787-59ad-4acd-bd0d-000000000000", "occurrenceTime": "MY_TIMESTAMP", "summary": "Summary - Problem test02", "severity": 5, "type": { "eventType": "problem", "classification": "EventType" }, "expirySeconds": 6000000, "links": [ { "linkType": "webpage", "name": "LinkName", "description": "LinkDescription", "url": "https://pirsoscom.github.io/git-commit-mysql-vm.html" } ], "sender": { "type": "host", "name": "SenderName", "sourceId": "SenderSource" }, "resource": { "type": "host", "name": "test02", "sourceId": "ResourceSorce" }, "details": { "Tag1Name": "Tag1", "Tag2Name": "Tag2" }}
{ "id": "1a2a6787-59ad-4acd-bd0d-000000000000", "occurrenceTime": "MY_TIMESTAMP", "summary": "Summary - Problem test03", "severity": 4, "type": { "eventType": "problem", "classification": "EventType" }, "expirySeconds": 6000000, "links": [ { "linkType": "webpage", "name": "LinkName", "description": "LinkDescription", "url": "https://pirsoscom.github.io/git-commit-mysql-vm.html" } ], "sender": { "type": "host", "name": "SenderName", "sourceId": "SenderSource" }, "resource": { "type": "host", "name": "test03", "sourceId": "ResourceSorce" }, "details": { "Tag1Name": "Tag1", "Tag2Name": "Tag2" }}'


 


# ----------------------------------------------------------------------------------------------------------------------------------------------------
# Custom Properties
# ----------------------------------------------------------------------------------------------------------------------------------------------------
# Simulate change in an Topology Objects Propoerties.
#
#   - `CUSTOM_PROPERTY_RESOURCE_NAME` : The Name of the resource to be affected 
#   - `CUSTOM_PROPERTY_RESOURCE_TYPE` : The Type of the resource to be affected
#   - `CUSTOM_PROPERTY_VALUES_NOK` : The values to be added/created when the Incident is being simulated
#   - `CUSTOM_PROPERTY_VALUES_OK` : The values to be added/created when the Incident is being mitigaged
#

export CUSTOM_PROPERTY_RESOURCE_NAME='Deployment1'
export CUSTOM_PROPERTY_RESOURCE_TYPE='deployment'
export CUSTOM_PROPERTY_VALUES_NOK='{"test1": "NOK","test2": "NOK","test3": "NOK"}'
export CUSTOM_PROPERTY_VALUES_OK='{"test1": "OK","test2": "OK","test3": "OK"}'





