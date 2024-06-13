export TOPOLOGY_NAME=london-underground
cd ansible


echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 TOPOLOGY - LOAD TOPOLOGY CONFIGURATION - $TOPOLOGY_NAME"
echo "----------------------------------------------------------------------------------------------------------"


export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
echo "    LOGIN: $LOGIN"


# echo "Delete existing Topology Customization"
# curl -XGET -k \
# "$TOPO_MGT_ROUTE/1.0/topology/metadata?_field=*" \
# -H 'accept: application/json' \
# -H 'content-type: application/json' \
# -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
# -u $LOGIN|jq -r '._items[] | select(.maxLabelLength=="")|._id'>/tmp/customItems.json

# cat /tmp/customItems.json

# while read line; 
# do 
#   echo "DELETE: $line"
#   curl -XDELETE -k \
#   "$TOPO_MGT_ROUTE/1.0/topology/metadata/$line" \
#   -H 'accept: application/json' \
#   -H 'content-type: application/json' \
#   -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
#   -u $LOGIN
# done < /tmp/customItems.json



echo "Upload Topology Customization"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      TOPOLOGY_CUSTOM_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/"$TOPOLOGY_NAME"-asm_config.json"
else
      TOPOLOGY_CUSTOM_FILE="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/topology/"$TOPOLOGY_NAME"-asm_config.json"
fi    
kubectl cp $TOPOLOGY_CUSTOM_FILE -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}'):/opt/ibm/netcool/asm/data/tools/"$TOPOLOGY_NAME"-asm_config.json 

sleep 30 

echo "Import Topology Customization"
#kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- find /opt/ibm/netcool/asm/data/tools/
kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- /opt/ibm/graph.tools/bin/import_ui_config -file $TOPOLOGY_NAME-asm_config.json





echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 TOPOLOGY - COPY OVERLAY TOPOLOGY TO POD - $TOPOLOGY_NAME"
echo "----------------------------------------------------------------------------------------------------------"
echo "Create Custom Topology - Copy Topology to File Observer"


# Get FILE_OBSERVER_POD
FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
echo $FILE_OBSERVER_POD
LOAD_FILE_NAME=$TOPOLOGY_NAME"-file.txt"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      FILE_OBSERVER_CAP=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
else
      FILE_OBSERVER_CAP="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
fi    
echo $FILE_OBSERVER_POD
echo $FILE_OBSERVER_CAP
echo $TARGET_FILE_PATH
TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
echo "  Copying capture file [${FILE_OBSERVER_CAP}] to file observer pod"
echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}






echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 TOPOLOGY - CREATE OVERLAY TOPOLOGY - $TOPOLOGY_NAME"
echo "----------------------------------------------------------------------------------------------------------"
echo "Create Custom Topology - Create File Observer Job"


export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
LOAD_FILE_NAME=$TOPOLOGY_NAME"-file.txt"
TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"


# Get Credentials
export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
export JOB_ID=$TOPOLOGY_NAME"-topology"

echo "  URL: $TOPO_ROUTE"
echo "  LOGIN: $LOGIN"
echo "  JOB_ID: $JOB_ID"


# Get FILE_OBSERVER JOB
curl -X "POST" "$TOPO_ROUTE/1.0/file-observer/jobs" --insecure \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -u $LOGIN \
  -d "{
  \"unique_id\": \"${JOB_ID}\",
  \"description\": \"Automatically created by Nicks scripts\",
  \"parameters\": {
      \"file\": \"${TARGET_FILE_PATH}\"
      }
  }"




# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE APPLICATION 
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------

export APP_NAME=underground-central

echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 TOPOLOGY - CREATE APPLICATION - $APP_NAME"
echo "----------------------------------------------------------------------------------------------------------"

export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D"$APP_NAME"-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
export TEMPLATE_ID_1=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3DTube%20zone%201" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
export TEMPLATE_ID_2=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3DTube%20zone%201%2B2" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

echo "    APP_ID:     "$APP_ID
echo "    TEMPLATE_ID_1:"$TEMPLATE_ID_1
echo "    TEMPLATE_ID_2:"$TEMPLATE_ID_2

echo "Create Custom Topology - Create App"

if [[ $APP_ID == "" ]];
then    
  echo "  Creating Application"
  curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -d '  {
      "keyIndexName": "'$APP_NAME'-app",
      "_correlationEnabled": "true",
      "iconId": "Underground",
      "businessCriticality": "Platinum",
      "vertexType": "group",
      "correlatable": "true",
      "disruptionCostPerMin": "200",
      "name": "Central London stations",
      "entityTypes": [
          "waiopsApplication"
      ],
      "tags": [
        "London",
        "underground"
      ]
  }
'
else
  echo "  Application already exists"
  echo "  Re-Creating Application"
  curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

  echo "  Creating Application"
  curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -d '  {
      "keyIndexName": "'$APP_NAME'-app",
      "_correlationEnabled": "true",
      "iconId": "Underground",
      "businessCriticality": "Platinum",
      "vertexType": "group",
      "correlatable": "true",
      "disruptionCostPerMin": "200",
      "name": "Central London stations",
      "entityTypes": [
          "waiopsApplication"
      ],
      "tags": [
        "London",
        "underground"
      ]
  }
'
fi

export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dunderground-central-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
echo "    APP_ID:     "$APP_ID

echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 ADD RESOURCES TO  APPLICATION- $APP_NAME"
echo "----------------------------------------------------------------------------------------------------------"

echo "  Add Template 1 Resources"
curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
-u $LOGIN \
-H 'Content-Type: application/json' \
-H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-d "{
  \"_id\": \"$TEMPLATE_ID_1\"
}"

echo "  Add Template 2 Resources"
curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
-u $LOGIN \
-H 'Content-Type: application/json' \
-H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-d "{
  \"_id\": \"$TEMPLATE_ID_2\"
}"



# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE APPLICATION 
# ----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------

export APP_NAME=underground-inner

echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 TOPOLOGY - CREATE APPLICATION - $APP_NAME"
echo "----------------------------------------------------------------------------------------------------------"

export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D"$APP_NAME"-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
export TEMPLATE_ID_1=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3DTube%20zone%202" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
export TEMPLATE_ID_2=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3DTube%20zone%202%2B3" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
export TEMPLATE_ID_3=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3DTube%20zone%202%2F3" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

echo "    APP_ID:     "$APP_ID
echo "    TEMPLATE_ID_1:"$TEMPLATE_ID_1
echo "    TEMPLATE_ID_2:"$TEMPLATE_ID_2
echo "    TEMPLATE_ID_3:"$TEMPLATE_ID_3

echo "Create Custom Topology - Create App"

if [[ $APP_ID == "" ]];
then    
  echo "  Creating Application"
  curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -d '  {
      "keyIndexName": "'$APP_NAME'-app",
      "_correlationEnabled": "true",
      "iconId": "Underground",
      "businessCriticality": "Platinum",
      "vertexType": "group",
      "correlatable": "true",
      "disruptionCostPerMin": "200",
      "name": "Inner London stations",
      "entityTypes": [
          "waiopsApplication"
      ],
      "tags": [
        "London",
        "underground"
      ]
  }
'
else
  echo "  Application already exists"
  echo "  Re-Creating Application"
  curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

  echo "  Creating Application"
  curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
  -u $LOGIN \
  -H 'Content-Type: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -d '  {
      "keyIndexName": "'$APP_NAME'-app",
      "_correlationEnabled": "true",
      "iconId": "Underground",
      "businessCriticality": "Platinum",
      "vertexType": "group",
      "correlatable": "true",
      "disruptionCostPerMin": "200",
      "name": "Central London stations",
      "entityTypes": [
          "waiopsApplication"
      ],
      "tags": [
        "London",
        "underground"
      ]
  }
'
fi

export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D"$APP_NAME"-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
echo "    APP_ID:     "$APP_ID

echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 ADD RESOURCES TO  APPLICATION- $APP_NAME"
echo "----------------------------------------------------------------------------------------------------------"

echo "  Add Template 1 Resources"
curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
-u $LOGIN \
-H 'Content-Type: application/json' \
-H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-d "{
  \"_id\": \"$TEMPLATE_ID_1\"
}"

echo "  Add Template 2 Resources"
curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
-u $LOGIN \
-H 'Content-Type: application/json' \
-H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-d "{
  \"_id\": \"$TEMPLATE_ID_2\"
}"


echo "  Add Template 3 Resources"
curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
-u $LOGIN \
-H 'Content-Type: application/json' \
-H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-d "{
  \"_id\": \"$TEMPLATE_ID_3\"
}"




echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo "🚀 CREATE POLICIES - $APP_NAME"
echo "----------------------------------------------------------------------------------------------------------"
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export POLICY_USERNAME=$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-lifecycle-policy-registry-svc -o jsonpath='{.data.username}' | base64 --decode)
export POLICY_PASSWORD=$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-lifecycle-policy-registry-svc -o jsonpath='{.data.password}' | base64 --decode)
export POLICY_LOGIN="$POLICY_USERNAME:$POLICY_PASSWORD"
echo $POLICY_LOGIN


export POLICY_ROUTE=$(oc get routes -n $AIOPS_NAMESPACE policy-api -o jsonpath="{['spec']['host']}")
echo $POLICY_ROUTE





export POLICY_ID=london-underground-high
export POLICY_NAME="DEMO London-Underground - No service"

echo "----------------------------------------------------------------------------------------------------------"
echo "🛠️  POLICIES - Create Incident Creation Policy - $POLICY_NAME"

echo "Upload Topology Customization"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      POLICY_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
else
      POLICY_FILE="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
fi    

oc create route passthrough --insecure-policy="Redirect" policy-api -n $AIOPS_NAMESPACE --service aiops-ir-lifecycle-policy-registry-svc --port ssl-port

export POLICY_ROUTE=""
while [[ $POLICY_ROUTE == "" ]]; do
  export POLICY_ROUTE=$(oc get routes -n $AIOPS_NAMESPACE policy-api -o jsonpath="{['spec']['host']}")
done
echo "POLICY_ROUTE: "$POLICY_ROUTE



export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN|grep $POLICY_NAME|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then
    export result="Create Incident Creation Policy "
    export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN \
    -d @/tmp/incident_policy.json)
else 
    export result="Already exists"
fi 
echo $result




export POLICY_ID=london-underground-med
export POLICY_NAME="DEMO London-Underground - Severe delays"

echo "----------------------------------------------------------------------------------------------------------"
echo "🛠️  POLICIES - Create Incident Creation Policy - $POLICY_NAME"

echo "Upload Topology Customization"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      POLICY_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
else
      POLICY_FILE="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
fi    

echo $POLICY_FILE
cp $POLICY_FILE /tmp/incident_policy.json


export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN|grep $POLICY_NAME|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then
    export result="Create Incident Creation Policy "
    export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN \
    -d @/tmp/incident_policy.json)
else 
    export result="Already exists"
fi 
echo $result





export POLICY_ID=london-underground-low
export POLICY_NAME="DEMO London-Underground - Catch All"

echo "----------------------------------------------------------------------------------------------------------"
echo "🛠️  POLICIES - Create Incident Creation Policy - $POLICY_NAME"

echo "Upload Topology Customization"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      POLICY_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
else
      POLICY_FILE="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID"-incident-creation-policy.json"
fi    

echo $POLICY_FILE
cp $POLICY_FILE /tmp/incident_policy.json


export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN|grep $POLICY_NAME|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then
    export result="Create Incident Creation Policy "
    export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN \
    -d @/tmp/incident_policy.json)
else 
    export result="Already exists"
fi 
echo $result




export POLICY_ID=london-underground-scope-based-grouping
export POLICY_NAME="DEMO London-Underground - Scope Grouping"

echo "----------------------------------------------------------------------------------------------------------"
echo "🛠️  POLICIES - Create Scope Policy - $POLICY_NAME"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "MAC"
      POLICY_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID".json"
else
      POLICY_FILE="ibm-aiops-deployer/ansible/roles/ibm-aiops-install-demo-content/templates/policies/"$POLICY_ID".json"
fi    

echo $POLICY_FILE
cp $POLICY_FILE /tmp/incident_policy.json


export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN|grep $POLICY_NAME|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then
    export result="Create Incident Creation Policy "
    export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -H 'content-type: application/json' \
    -u $POLICY_LOGIN \
    -d @/tmp/incident_policy.json)
else 
    export result="Already exists"
fi 
echo $result

