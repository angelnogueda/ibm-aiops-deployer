#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#         ________  __  ___     ___    ________       
#        /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____
#        / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/
#      _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) 
#     /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  
#                                           /_/
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------"
#  Init Customization
#
#    - Load Topology
#    - Set/Reset OK Custom Properties
#
#
#
#  CloudPak for AIOps
#
#  ©2024 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


. ./0_configuration.sh


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SED="sed"
if [ "${OS}" == "darwin" ]; then
    SED="gsed"
    if [ ! -x "$(command -v ${SED})"  ]; then
    echo "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
    exit
    fi
fi
 

clear

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo ""
echo ""
echo "         ________  __  ___     ___    ________       "     
echo "        /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____"
echo "        / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/"
echo "      _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) "
echo "     /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  "
echo "                                           /_/            "
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  Init Customization"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------"



echo "🟣    ---------------------------------------------------------------------------------------------"
echo "🟣     🔎 CUSTOM Simulation Parameters"
echo "🟣    ---------------------------------------------------------------------------------------------"
echo "🟣           ❗ CUSTOM_EVENTS:                  Number of events: $(echo "$CUSTOM_EVENTS" | wc -l|tr -d ' ')"
echo "🟣           📦 CUSTOM_TOPOLOGY_APP_NAME:       $CUSTOM_TOPOLOGY_APP_NAME"
echo "🟣           📛 CUSTOM_TOPOLOGY_TAG:            $CUSTOM_TOPOLOGY_TAG"
echo "🟣           🧾 CUSTOM_TOPOLOGY:                Number of entities: $(echo "$CUSTOM_TOPOLOGY" | wc -l|tr -d ' ')"
echo "🟣           📥 CUSTOM_PROPERTY_RESOURCE_NAME:  $CUSTOM_PROPERTY_RESOURCE_NAME"
echo "🟣           🛠️ CUSTOM_PROPERTY_RESOURCE_TYPE:  $CUSTOM_PROPERTY_RESOURCE_TYPE"
echo "🟣           🟩 CUSTOM_PROPERTY_VALUES_OK:      $CUSTOM_PROPERTY_VALUES_OK"
echo "🟣           🟥 CUSTOM_PROPERTY_VALUES_NOK:     $CUSTOM_PROPERTY_VALUES_NOK"


echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 0: Initialization"
echo ""
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ AIOps Namespace:        $AIOPS_NAMESPACE"
    echo "     🛠️ Create Routes"
    # oc create route passthrough topology-file-api -n $AIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-file-observer --port=https-file-observer-api
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    oc create route passthrough --insecure-policy="Redirect" datalayer-api -n $AIOPS_NAMESPACE  --service=aiops-ir-core-ncodl-api --port=secure-port --insecure-policy=Redirect --wildcard-policy=None
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Get Connection Details"
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Topology File URL:      $TOPO_ROUTE"
    echo "     🛠️ Topology Mgt URL:       $TOPO_MGT_ROUTE"
    echo "     🛠️ Login:                  $LOGIN"


echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 1: Uploading Template File"
echo ""


    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Uploading Custom Topology
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    echo "$CUSTOM_TOPOLOGY"  > /tmp/custom-topology.txt

    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    LOAD_FILE_NAME="custom-topology.txt"

    FILE_OBSERVER_CAP=/tmp/custom-topology.txt

    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ File Observer Pod:      $FILE_OBSERVER_POD"
    echo "     🛠️ Topology File Local:    $FILE_OBSERVER_CAP"
    echo "     🛠️ Topology File Remote:   $TARGET_FILE_PATH"

    echo "     🌶️ Copying capture file to file observer pod"
    oc cp -n $AIOPS_NAMESPACE -c aiops-topology-file-observer ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}



echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 2: Uploading Template File"
echo ""

    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology File Observer
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    LOAD_FILE_NAME="custom-topology.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"

    # Get Credentials
    export JOB_ID=custom-topology

    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Target File Path:       $TARGET_FILE_PATH"
    echo "     🛠️ Observer Job ID:        $JOB_ID"

    echo '{\"unique_id\": \"'$JOB_ID'\",\"description\": \"Automatically created by Nicks scripts\",\"parameters\": {\"file\": \"/opt/ibm/netcool/asm/data/file-observer/custom-topology.txt\"}}' > /tmp/custom-topology-observer.txt
    echo '{"unique_id": "'$JOB_ID'","description": "Automatically created by Nicks scripts","parameters": {"file": "/opt/ibm/netcool/asm/data/file-observer/custom-topology.txt"}}' > /tmp/custom-topology-observer.txt
        
    # Create FILE_OBSERVER JOB
    curl -X "POST"  "$TOPO_ROUTE/1.0/file-observer/jobs" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H "accept: application/json" \
        -H "Content-Type: application/json"\
        -u $LOGIN \
        -d @/tmp/custom-topology-observer.txt

    echo "     ⏳ Observer created - waiting 30 seconds"
    sleep 30

    detectedEntities=$(curl -X "GET" -s "$TOPO_ROUTE/1.0/file-observer/observations?_field=*" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H "accept: application/json" \
        -H "Content-Type: application/json"\
        -u $LOGIN | jq '._items[] | select( .keyIndexName == "file-observer:custom-topology" )|.observationCount')

    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Detected Entities:      $detectedEntities   (must be bigger than 0)"




echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 3: Creating Custom Topology Template"
echo ""


    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology Template
    # ----------------------------------------------------------------------------------------------------------------------------------------------------

    export TEMPLATE_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dcustom-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Existing Template:      $TEMPLATE_ID"


    if [ -z "$TEMPLATE_ID" ]
    then
        echo "     🌶️ Creating Template"
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d '  {
            "keyIndexName": "custom-template",
            "_correlationEnabled": "true",
            "iconId": "application",
            "businessCriticality": "Gold",
            "vertexType": "group",
            "groupTokens": [
                "'$CUSTOM_TOPOLOGY_TAG'"
            ],
            "correlatable": "true",
            "name": "custom-template",
            "entityTypes": [
                "completeGroup",
                "compute"
            ],
            "tags": [
                "demo"
            ]
        }'
    else
        echo "     🌶️ Template already exists"
        echo "     🌶️ Re-Creating Template"
        curl -s -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

        
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d '  {
            "keyIndexName": "custom-template",
            "_correlationEnabled": "true",
            "iconId": "application",
            "businessCriticality": "Gold",
            "vertexType": "group",
            "groupTokens": [
                "'$CUSTOM_TOPOLOGY_TAG'"
            ],
            "correlatable": "true",
            "name": "custom-template",
            "entityTypes": [
                "completeGroup",
                "compute"
            ],
            "tags": [
                "demo"
            ]
        }'
    fi


echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 4: Creating Custom Topology Application"
echo ""


    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology Application
    # ----------------------------------------------------------------------------------------------------------------------------------------------------

    export APP_NAME=$CUSTOM_TOPOLOGY_APP_NAME
    export APP_NAME_ID=$(echo $APP_NAME| tr '[:upper:]' '[:lower:]'| tr ' ' '-')
    export APP_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D$APP_NAME_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dcustom-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Application Name:       $APP_NAME"
    echo "     🛠️ Application Name ID:    $APP_NAME_ID"
    echo "     🛠️ Existing Application:   $APP_ID"
    echo "     🛠️ Existing Template:      $TEMPLATE_ID"


    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🌶️ Create Custom Topology - Create App"

    echo '{"keyIndexName": "'$APP_NAME_ID'","_correlationEnabled": "true","iconId": "cluster","businessCriticality": "Platinum","vertexType": "group","correlatable": "true","disruptionCostPerMin": "1000","name": "'$APP_NAME'","entityTypes": ["waiopsApplication"],"tags": ["app:'$APP_NAME_ID'"]}' > /tmp/custom-topology-app.txt


    if [ -z "$APP_ID" ]
    then    
        echo "     🌶️ Create Custom Topology - Create App"
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d @/tmp/custom-topology-app.txt
    else
        echo "     🌶️ Application already exists"
        echo "     🌶️ Re-Creating Application"
        curl -s -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'


        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d @/tmp/custom-topology-app.txt
    fi

    export APP_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D$APP_NAME_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Existing Application:   $APP_ID"

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------

    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🌶️ Add Template (File Observer) Resources"
    curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d '{
        "_id": "'$TEMPLATE_ID'"
    }'




echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 5: Set Custom Properties"
echo ""

    echo "----------------------------------------------------------------------------------------------------------"
    echo "     🌶️ Set Custom Properties for $CUSTOM_PROPERTY_RESOURCE_NAME "

    export OBJ_ID=$(curl -k -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name=$CUSTOM_PROPERTY_RESOURCE_NAME&_filter=entityTypes=$CUSTOM_PROPERTY_RESOURCE_TYPE&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ ID for Entitiy:         $OBJ_ID"

    export result=$(curl -k -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$OBJ_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d "$CUSTOM_PROPERTY_VALUES_OK")


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " ✅ DONE"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"




exit 1
