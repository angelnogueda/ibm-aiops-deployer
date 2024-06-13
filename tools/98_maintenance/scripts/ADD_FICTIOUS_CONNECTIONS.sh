echo "*****************************************************************************************************************************"
echo " ✅ STARTING: ADD NON FUNCTIONING CONNECTIONS FOR DEMO SYSTEMS"
echo "*****************************************************************************************************************************"



# ADD NON FUNCTIONING CONNECTIONS FOR DEMO SYSTEMS

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
export CPD_ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export AIO_PLATFORM_ROUTE=$(oc get route -n $AIOPS_NAMESPACE aimanager-aio-controller -o jsonpath={.spec.host})

echo "        Namespace:          $AIOPS_NAMESPACE"
echo "        CPD_ROUTE:          $CPD_ROUTE"
echo "        AIO_PLATFORM_ROUTE: $AIO_PLATFORM_ROUTE"


echo "       🛠️   Getting ZEN Token"

export CONSOLE_ROUTE=$(oc get route -n $AIOPS_NAMESPACE cp-console  -o jsonpath={.spec.host})          
echo ""
export CPD_ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd  -o jsonpath={.spec.host})          
export CPADMIN_PWD=$(oc -n $AIOPS_NAMESPACE get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d && echo)
export CPADMIN_USER=$(oc -n $AIOPS_NAMESPACE get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 -d && echo)
export ACCESS_TOKEN=$(curl -s -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username=$CPADMIN_USER&password=$CPADMIN_PWD&scope=openid" https://$CONSOLE_ROUTE/idprovider/v1/auth/identitytoken|jq -r '.access_token')
export ZEN_API_HOST=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath='{.spec.host}')
export ZEN_TOKEN=$(curl -k -XGET https://$ZEN_API_HOST/v1/preauth/validateAuth \
-H "username: $CPADMIN_USER" \
-H "iam-token: $ACCESS_TOKEN"|jq -r '.accessToken')
echo "        ACCESS_TOKEN: $ZEN_TOKEN"

echo "${ZEN_TOKEN}"
echo "        AI_PLATFORM_ROUTE:  $ZEN_TOKEN"

echo "Sucessfully logged in" 
echo ""





# --------------------------------------------------------------------------------------------------------
# ADD GITHUB
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
  "displayName": "GitHubDemo",
  "connection_type": "github",
  "connection_config": {
    "collectionMode": "live",
    "data_flow": false,
    "issueSamplingRate": 1,
    "mappingsGithub": "({\n    \"title\": $string(incident.title),\n    \"body\": $join([\"Incident Id:\", $string(incident.id),\n                   \"\\nAIOPS Incident Overview URL: https://\", $string(URL_PREFIX), \"/aiops/default/resolution-hub/incidents/all/\", $string(incident.id), \"/overview\",\n                   \"\\nStatus: \", $string(incident.state),\n                   \"\\nDescription: \", $string(incident.description)]),\n    \"labels\": [$join([\"priority:\", $string(incident.priority)])]\n})\n",
    "owner": "niklaushirt",
    "repo": "niklaushirt",
    "token": "",
    "url": "https://github.com/",
    "username": "niklaushirt",
    "display_name": "GitHubDemo",
    "deploymentType": "local"
  },
  "connection_id": "github-demo"
}'


# --------------------------------------------------------------------------------------------------------
# ADD oiObjectserverDemo1
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "displayName": "NoiObjectserverDemoTest",
    "status": "Disabled",
    "connection_type": "netcool-connector",
    "connection_config": {
        "backup_objectserver": {
            "api_port": 4200
        },
        "collectAlerts": true,
        "filter": "",
        "mapping": "{}",
        "password": "",
        "primary_objectserver": {
            "api_port": 4100,
            "url": "https://primary-objectserver-test.demo.ibm.com"
        },
        "tls": false,
        "username": "nhirt",
        "display_name": "NoiObjectserverDemoTest",
        "deploymentType": "local"
    },
    "connection_id": "noiobjectserver-demo-test"
}'


# --------------------------------------------------------------------------------------------------------
# ADD oiObjectserverDemo2
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "displayName": "NoiObjectserverDemoProd",
    "status": "Disabled",
    "connection_type": "netcool-connector",
    "connection_config": {
        "backup_objectserver": {
            "api_port": 4200
        },
        "collectAlerts": true,
        "filter": "",
        "mapping": "{}",
        "password": "",
        "primary_objectserver": {
            "api_port": 4100,
            "url": "https://primary-objectserver-prod.demo.ibm.com"
        },
        "tls": false,
        "username": "nhirt",
        "display_name": "NoiObjectserverDemoProd",
        "deploymentType": "local"
    },
    "connection_id": "noiobjectserver-demo-prod"
}'

# --------------------------------------------------------------------------------------------------------
# ADD NOIImpactDemo
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "displayName": "NOIImpactDemo",
    "connection_type": "ibm-grpc-impact-connector",
    "connection_config": {
        "backendUrl": "https://primary-objectserver.demo.ibm.com",
        "password": "",
        "url": "https://impact.demo.ibm.com",
        "username": "admin",
        "display_name": "NOIImpactDemo",
        "deploymentType": "local"
    },
    "connection_id": "impact-demo"
}
'


# --------------------------------------------------------------------------------------------------------
# ADD InstanaDemo
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "connection_config": {
        "deploymentType": "local",
        "topology": {
            "enable_topology_flow": true,
            "time_window": 86400,
            "connection_interval": 600,
            "white_list_pattern": ".*",
            "import_app_perspectives_as_aiops_apps": true
        },
        "event": {
            "enable_event_flow": true,
            "types": ["incident"]
        },
        "metric": {
            "enable_metric_flow": true,
            "plugin_selection_option": "[]",
            "collect_live_data_flow": true,
            "aggregation_interval": 5
        },
        "using_proxy": false,
        "display_name": "InstanaDemo",
        "endpoint": "https://instana.demo.ibm.com",
        "api_token": "aaaaaaaa"
    },
    "connectorConfig": {
        "AIModelTypeList": ["{{sidePanel.AIModelTypes.probableCause}}", "{{sidePanel.AIModelTypes.temporalCorrelation}}"],
        "apiAdaptor": "grpc",
        "categories": ["{{connector.common.category.events}}", "{{connector.common.category.metrics}}", "{{connector.common.category.topology}}"],
        "datasourceType": "events",
        "deploymentType": ["local", "remote"],
        "displayName": "{{connector.instana.name}}",
        "hasAIModelType": true,
        "hasOptionalConfig": true,
        "hasOptionalText": false,
        "iconFileType": "png",
        "isIBM": true,
        "requiresTestConnection": false,
        "sidePanelDescription": "{{connector.instana.sidepanel.description}}",
        "sidePanelInfo": ["{{sidePanel.information.instana.2}}", "{{sidePanel.information.instana.4}}", "{{sidePanel.information.instana.6}}", "{{sidePanel.information.instana.5}}"],
        "sidePanelInfoHeader": "{{sidePanel.information.header}}",
        "sidePanelOptionalConfigHeader": "{{sidePanel.optional.instana.header}}",
        "sidePanelOptionalConfigList": ["{{sidePanel.optional.instana.topology}}", "{{sidePanel.optional.instana.event}}", "{{sidePanel.optional.instana.metric}}"],
        "sidePanelTitle": "{{sidePanel.title.instana}}",
        "type": "instana",
        "url": "https://ibm.biz/int-instana"
    }
}'








# --------------------------------------------------------------------------------------------------------
# ADD GenericWebhookDemo
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "connection_config": {
        "webhook": {
            "authentication": {
                "type": "basic_authentication",
                "credentials": {
                    "username": "demo",
                    "password": "demo"
                }
            },
            "enabled": true,
            "path": "/webhook-connector/5596czc2bu8",
            "mappings": "(\n    {\n        \"severity\": risk.severity = \"MINOR\" ? 3 : risk.severity = \"MAJOR\" ? 4 : risk.severity = \"CRITICAL\" ? 6 : risk.severity= \"UNKNOWN\" ? 1 : 2,\n        \"summary\": details,\n        \"resource\": {\n            \"name\": target.displayName,\n            \"sourceId\": target.uuid\n        },\n        \"type\": {\n            \"classification\": target.className,\n            \"eventType\": actionState = \"CLEARED\" ? \"resolution\":actionState = \"SUCCEEDED\" ? \"resolution\" : \"problem\",\n            \"condition\": risk.subCategory\n        },\n        \"sender\": {\n            \"name\": \"IBM Turbonomic\",\n            \"type\": \"Webhook Connector\"\n        }\n    }\n)"
        },
        "deploymentType": "local",
        "display_name": "GenericWebhookDemo",
        "connectionName": "GenericWebhookDemo"
    },
    "connectorConfig": {
        "AIModelTypeList": ["{{sidePanel.AIModelTypes.logAnomaly}}"],
        "apiAdaptor": "grpc",
        "categories": ["{{connector.common.category.events}}"],
        "datasourceType": "events",
        "deploymentType": ["local"],
        "displayName": "{{connector.webhook.name}}",
        "hasAIModelType": false,
        "hasOptionalConfig": true,
        "hasOptionalText": false,
        "iconFileType": "svg",
        "isObserver": false,
        "requiresTestConnection": false,
        "sidePanelDescription": "{{connector.webhook.sidepanel.sidePanelDescription}}",
        "sidePanelInfo": ["{{sidePanel.information.webhook.1}}", "{{sidePanel.information.webhook.2}}", "{{sidePanel.information.webhook.3}}"],
        "sidePanelInfoHeader": "{{sidePanel.information.header}}",
        "sidePanelOptionalConfigHeader": "{{sidePanel.webhook.optional.config.header}}",
        "sidePanelOptionalConfigList": ["{{sidePanel.webhook.optional.config.1}}"],
        "sidePanelTitle": "{{connector.webhook.sidepanel.sidePanelTitle}}",
        "type": "webhook",
        "url": "https://ibm.biz/aiops-genwebhook"
    }
}'



# --------------------------------------------------------------------------------------------------------
# ADD EmailDemo
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "connection_config": {
        "emailPort": 25,
        "deploymentType": "local",
        "createMappings": "({\n    \"subject\": $join([\"Incident Created: \", $string(incident.title)]),\n    \"message\": $join([\"AIOPS Incident Overview URL: https://\", $string(URL_PREFIX), \"/aiops/default/resolution-hub/incidents/all/\", $string(incident.id), \"/overview\",\n                      \"\\nPriority: \", $string(incident.priority),\n                      \"\\nStatus: \", $string(incident.state),\n                      \"\\nTime opened: \", $string(incident.createdTime),\n                      \"\\nGroup: \", $string(incident.team),\n                      \"\\nOwner: \", $string(incident.owner),\n                      \"\\nDescription: \", $string(incident.description)])\n})\n",
        "closeMappings": "({\n    \"subject\": $join([\"Incident Closed: \", $string(incident.title)]),\n    \"message\": $join([\"Incident ID: \", $string(incident.id),\n                      \"\\nPriority: \", $string(incident.priority),\n                      \"\\nStatus: \", $string(incident.state),\n                      \"\\nTime opened: \", $string(incident.createdTime),\n                      \"\\nGroup: \", $string(incident.team),\n                      \"\\nOwner: \", $string(incident.owner),\n                      \"\\nDescription: \", $string(incident.description)])\n})\n",
        "display_name": "EmailDemo",
        "emailHost": "mysmtp.ibm.com",
        "emailSource": "demo@ibm.com",
        "emailSecret": "aaaaa",
        "recipients": "demo@ibm.com"
    },
    "connectorConfig": {
        "apiAdaptor": "grpc",
        "categories": ["{{connector.common.category.notifications}}"],
        "datasourceType": "events",
        "deploymentType": ["local", "remote"],
        "displayName": "{{connector.email.name}}",
        "hasAIModelType": false,
        "hasOptionalConfig": false,
        "hasOptionalText": false,
        "hasOtherConsiderations": true,
        "iconFileType": "svg",
        "isIBM": true,
        "otherConsideration": "{{connector.email.sidePanel.otherConsideration}}",
        "sidePanelDescription": "{{connector.email.sidePanelDescription}}",
        "sidePanelInfo": ["{{connector.email.sidePanelInfo.1}}", "{{connector.email.sidePanelInfo.2}}", "{{connector.email.sidePanelInfo.3}}", "{{connector.email.sidePanelInfo.4}}", "{{connector.email.sidePanelInfo.5}}", "{{connector.email.sidePanelInfo.6}}"],
        "sidePanelInfoHeader": "{{sidePanel.information.header}}",
        "sidePanelTitle": "{{connector.email.sidePanelTitle}}",
        "type": "email-notifications",
        "url": "https://ibm.biz/int-email-notification"
    }
}'


# --------------------------------------------------------------------------------------------------------
# ADD DynatraceDemo
# --------------------------------------------------------------------------------------------------------
curl "https://$CPD_ROUTE/aiops/integrations/api/controller/grpc/connections/" \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'x-tenantid: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H "authorization: Bearer $ZEN_TOKEN"   \
--data-binary '{
    "connection_config": {
        "installationType": "local",
        "authType": "apitoken",
        "vault": {},
        "metrics": {
            "enabled": false,
            "poll_rate": 300
        },
        "events": {
            "enabled": true,
            "poll_rate": 60
        },
        "display_name": "DynatraceDemo",
        "dataSourceBaseUrl": "https://dynatrace.demo.ibm.com",
        "zone": "demo",
        "accessToken": "aaaa",
        "sensorName": "com.instana.plugin.dynatrace"
    },
    "connectorConfig": {
        "AIModelTypeList": ["{{sidePanel.AIModelTypes.metricAnomaly}}"],
        "apiAdaptor": "grpc",
        "categories": ["{{connector.common.category.metrics}}", "{{connector.common.category.events}}"],
        "datasourceType": "metrics,events",
        "deploymentType": ["local", "remote"],
        "displayName": "{{connector.dynatrace.name}}",
        "hasAIModelType": true,
        "hasOptionalConfig": true,
        "hasOptionalText": false,
        "iconFileName": "dynatrace",
        "iconFileType": "svg",
        "interviewExperience": "dynatrace",
        "isCommonCollector": true,
        "isTechnicalPreview": true,
        "sensorMapping": {
            "connection_config.accessToken": "key",
            "connection_config.dataSourceBaseUrl": "endpoint",
            "connection_config.enabled": "enabled",
            "connection_config.events": "events",
            "connection_config.metrics": "metrics",
            "connection_config.tags": "tags",
            "connection_config.vault.secretKey": "key.configuration_from.secret_key.key",
            "connection_config.vault.secretPath": "key.configuration_from.secret_key.path",
            "connection_config.vaultToken": "key.configuration_from.type",
            "connection_config.zone": "zone"
        },
        "sensorName": "com.instana.plugin.dynatrace",
        "sensorVaultPath": "key",
        "sidePanelDescription": "{{sidePanel.dynatrace.cdc.description}}",
        "sidePanelInfo": ["{{sidePanel.information.instana.2}}", "{{connector.common.form.access_token.label}}"],
        "sidePanelInfoHeader": "{{sidePanel.information.header}}",
        "sidePanelOptionalConfigHeader": "{{sidePanel.dynatrace.config.header}}",
        "sidePanelOptionalConfigList": ["{{sidePanel.dynatrace_agent.configList1}}", "{{sidePanel.dynatrace_agent.configList2}}"],
        "sidePanelTitle": "{{connector.dynatrace.sidePanelTitle}}",
        "type": "dynatrace-agent",
        "url": "https://ibm.biz/int-dynatrace-agent"
    }
}'


# --------------------------------------------------------------------------------------------------------
# ADD SlackDemo
# --------------------------------------------------------------------------------------------------------
curl -X 'POST' --insecure \
"https://$AIO_PLATFORM_ROUTE/v3/connections" \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
  -H "authorization: Bearer $ZEN_TOKEN"  \
-d '{
    "aiopsedge_id": "null",
    "application_group_id": "1000",
    "application_id": "1000",
    "connection_config": {
      "connection_type": "slack",
      "creator_user_name": "",
      "reactive_channel": "reactivechannel",
      "using_proxy": false,
      "proactive_channel": "proactivechannel",
      "lang_id": "en",
      "bot_token": "bottoken",
      "secret": "signingsecret",
      "display_name": "SlackDemo"
    },
    "connection_id": "443ad7c9-4b99-4172-85a5-9411c0073196",
    "connection_type": "slack",
    "connection_updated_at": "2024-05-24T07:39:08.249386Z",
    "created_at": "null",
    "created_by": "null",
    "data_flow": false,
    "datasource_type": "slack",
    "global_id": "4",
    "mapping": {},
    "name": "null",
    "request_action": "get",
    "state": "null",
    "updated_by": "null"
  }'




# --------------------------------------------------------------------------------------------------------
# ADD TeamsDemo
# --------------------------------------------------------------------------------------------------------
curl -X 'POST' --insecure \
"https://$AIO_PLATFORM_ROUTE/v3/connections" \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
  -H "authorization: Bearer $ZEN_TOKEN"  \
-d '{
      "aiopsedge_id": "null",
      "application_group_id": "1000",
      "application_id": "1000",
      "connection_config": {
        "connection_type": "teams",
        "creator_user_name": "",
        "reactive_channel": "reactivechannel",
        "using_proxy": false,
        "app_password": "apppassword",
        "proactive_channel": "proactivechannel",
        "lang_id": "en",
        "display_name": "Teams",
        "app_id": "dsafads"
      },
      "connection_id": "3be692db-0fac-4649-baed-9643b0495efd",
      "connection_type": "teams",
      "connection_updated_at": "2024-05-23T10:09:38.339959Z",
      "created_at": "null",
      "created_by": "null",
      "data_flow": false,
      "datasource_type": "teams",
      "global_id": "2",
      "mapping": {},
      "name": "null",
      "request_action": "get",
      "state": "null",
      "updated_by": "null"
    }'













echo "*****************************************************************************************************************************"
echo " ✅ DONE"
echo "*****************************************************************************************************************************"
