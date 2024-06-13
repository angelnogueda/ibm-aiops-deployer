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
#  Simulate Change
#
#    - Set/Reset Custom Properties
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



#clear

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
echo " 🚀  Simulate Change"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------"







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
echo "  🚀 STEP 1: Starting"
echo ""







while true; 
do

    export RANDOM_DELAY=$(( ( RANDOM % $RANDOM_DELAY_VALUE )  + ${RANDOM_DELAY_SKEW} ))
    #echo $RANDOM_DELAY

    export RANDOM_TPS=$(( ( RANDOM % $RANDOM_TPS_VALUE )  + ${RANDOM_TPS_SKEW} ))
    #echo $RANDOM_TPS

    export my_timestamp=$(date $EVENTS_SECONDS_SKEW $DATE_FORMAT_EVENTS)".000Z"

    for RESOURCE in "${CUSTOM_PROPERTY_RESOURCES[@]}"
    do
        export CUSTOM_PROPERTY_RESOURCE_NAME=$(echo $RESOURCE| cut -d ":" -f 1)
        export CUSTOM_PROPERTY_RESOURCE_TYPE=$(echo $RESOURCE| cut -d ":" -f 2)
        export OBJ_ID=$(curl -k -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name=$CUSTOM_PROPERTY_RESOURCE_NAME&_filter=entityTypes=$CUSTOM_PROPERTY_RESOURCE_TYPE&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=true" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
        echo "----------------------------------------------------------------------------------------------------------"
        echo "     🌶️ Update Properties for $CUSTOM_PROPERTY_RESOURCE_NAME : $CUSTOM_PROPERTY_RESOURCE_TYPE : $OBJ_ID"
        export result=$(curl -k -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$OBJ_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d "{\"timestamp\": \"$my_timestamp\",\"Transactions per Second\": \"$RANDOM_TPS\",\"test\": \"$RANDOM_DELAY\"}")
        #echo $result



        # echo "----------------------------------------------------------------------------------------------------------"
        # echo "     🌶️ Create Alert for $CUSTOM_PROPERTY_RESOURCE_NAME : $my_timestamp"
        # export line='{ "id": "1a2a6787-59ad-4acd-bd0d-MY_ID",  "occurrenceTime": "MY_TIMESTAMP", "summary": "Info -  Received MY_ID", "severity": 1, "type": { "eventType": "problem", "classification": "EventType" }, "expirySeconds": 2, "links": [ { "linkType": "webpage", "name": "LinkName", "description": "LinkDescription", "url": "https://pirsoscom.github.io/git-commit-mysql-vm.html" } ], "sender": { "type": "host", "name": "SenderName", "sourceId": "SenderSource" }, "resource": { "type": "deployment", "name": "mysql", "sourceId": "ResourceSorce" }, "details": { "Tag1Name": "Tag1", "Tag2Name": "Tag2" }}'


        # export my_timestamp=$(date $EVENTS_SECONDS_SKEW $DATE_FORMAT_EVENTS)".000Z"
        # export myID=$(date "+%s")$COUNTER

        # #echo "aaaaa: "$myID
        # # Replace in line
        # line=${line//MY_TIMESTAMP/$my_timestamp}
        # line=${line//MY_ID/$myID}
        # line=${line//\"/\\\"}

        # #echo $line

        # export c_string=$(echo "curl \"https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/events\" --insecure -s  -X POST -u \"${USER_PASS}\" -H 'Content-Type: application/json' -H 'x-username:admin' -H 'x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d \"${line}\"")
        # #echo "       Q:$c_string"
        # export result=$(eval $c_string)


    done




    echo "----------------------------------------------------------------------------------------------------------"
    echo "     ⏳ Waiting $RANDOM_DELAY s"
    sleep $RANDOM_DELAY
    echo "----------------------------------------------------------------------------------------------------------"
    echo "----------------------------------------------------------------------------------------------------------"

done

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