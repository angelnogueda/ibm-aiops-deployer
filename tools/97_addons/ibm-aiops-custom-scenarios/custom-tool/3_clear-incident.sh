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
#  Clear Custom Incident
#
#    - Clear Events
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
if [[ "${OS}" == "darwin" ]]; then
    SED="gsed"
    if [ ! -x "$(command -v ${SED})"  ]; then
    __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
    exit
    fi
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "${OS}" == "darwin" ]]; then
      # Suppose we're on Mac
      export DATE_FORMAT_EVENTS="+%Y-%m-%dT%H:%M:%S"
else
      # Suppose we're on a Linux flavour
      export DATE_FORMAT_EVENTS="+%Y-%m-%dT%H:%M:%S" 
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
echo " 🚀  Clear Custom Incident"
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
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export USER_PASS="$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-core-ncodl-api-secret -o jsonpath='{.data.username}' | base64 --decode):$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-core-ncodl-api-secret -o jsonpath='{.data.password}' | base64 --decode)"
    export DATALAYER_ROUTE=$(oc get route  -n $AIOPS_NAMESPACE datalayer-api  -o jsonpath='{.status.ingress[0].host}')

    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ Topology Mgt URL:       $TOPO_MGT_ROUTE"
    echo "     🛠️ TopologyLogin:          $LOGIN"
    echo "     🛠️ Datalayer URL:          $DATALAYER_ROUTE"
    echo "     🛠️ Datalayer Login:        $USER_PASS"



echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 1: Clearing Events"
echo ""
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🌶️ Clearing Events"

   
    curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/alerts" --insecure -s  -X PATCH -u "${USER_PASS}" -H 'Content-Type: application/json' -H 'x-username:admin' -H 'x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"state": "closed"}'|grep "affected"| sed 's/^/          /'
    curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/stories" --insecure -s  -X PATCH -u "${USER_PASS}" -H 'Content-Type: application/json' -H 'x-username:admin' -H 'x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"state": "inProgress"}'|grep "affected"| sed 's/^/          /'
    curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/stories" --insecure -s  -X PATCH -u "${USER_PASS}" -H 'Content-Type: application/json' -H 'x-username:admin' -H 'x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"state": "resolved"}'|grep "affected"| sed 's/^/          /'
    
    

echo ""
echo ""
echo ""
echo ""
echo "🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣"
echo ""
echo "  🚀 STEP 2: Set Custom Incident Properties"
echo ""

    echo "----------------------------------------------------------------------------------------------------------"
    echo "     🌶️ Set Custom Properties for $CUSTOM_PROPERTY_RESOURCE_NAME "

    export OBJ_ID=$(curl -k -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name=$CUSTOM_PROPERTY_RESOURCE_NAME&_filter=entityTypes=$CUSTOM_PROPERTY_RESOURCE_TYPE&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    
    echo ""
    echo "   --------------------------------------------------------------------------------------------------"
    echo "     🛠️ ID for Entitiy:         $OBJ_ID"

    export result=$(curl -k -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$OBJ_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d "$CUSTOM_PROPERTY_VALUES_OK")

echo ""
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " ✅ DONE"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

exit 1