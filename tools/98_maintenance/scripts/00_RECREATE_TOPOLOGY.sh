# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# DISABLE RULES
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------



# 🚀 TOPOLOGY - Disable Match Token RULE for Services

    CLUSTER_ROUTE=$(oc get routes console -n openshift-console | tail -n 1 2>&1 ) 
    CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
    CLUSTER_NAME=${CLUSTER_FQDN##*console.}

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    #oc delete route  topology-merge -n $AIOPS_NAMESPACE
    # oc create route passthrough topology-merge -n $AIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-merge --port=https-merge-api


    echo "URL: https://topology-merge-$AIOPS_NAMESPACE.$CLUSTER_NAME/1.0/merge/"
    echo "LOGIN: $LOGIN"


    echo "Wait 5 seconds"
    sleep 5

    echo "Disable Match Token RULE for Services..."

    export result=$(curl -X "GET" "https://topology-merge-$AIOPS_NAMESPACE.$CLUSTER_NAME/1.0/merge/rules?_filter=name%3Dk8sGenericNameMatchTokens&ruleType=matchTokensRule" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN)
    export ruleIDs=$(echo $result| jq "._items")

    export ruleID=$(echo $ruleIDs| jq -r ".[0]._id")

    curl -X "POST" "https://topology-merge-$AIOPS_NAMESPACE.$CLUSTER_NAME/1.0/merge/rules/$ruleID/?ruleType=matchTokensRule" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN \
        -d '{"ruleStatus": "disabled"}'



    echo "Disable Match Token RULE for Instana Services..."

    export result=$(curl -X "GET" "https://topology-merge-$AIOPS_NAMESPACE.$CLUSTER_NAME/1.0/merge/rules?_filter=name%3Dinstana-observer-events-kubernetes-service&ruleType=matchTokensRule" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN)
    export ruleIDs=$(echo $result| jq "._items")

    export ruleID=$(echo $ruleIDs| jq -r ".[0]._id")

    curl -X "POST" "https://topology-merge-$AIOPS_NAMESPACE.$CLUSTER_NAME/1.0/merge/rules/$ruleID/?ruleType=matchTokensRule" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN \
        -d '{"ruleStatus": "disabled"}'














# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# OBSERVERS
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# K8s OBSERVER  ROBOT SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------

# 🚀 TOPOLOGY - CREATE K8S OBSERVER ROBOT SHOP



    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    echo "Creating K8s Observer"


    # Create Route
    oc create route passthrough aiops-topology-kubernetes-observer -n $AIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-kubernetes-observer --port=https-kubernetes-observer-api

    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-kubernetes-observer -o jsonpath={.spec.host})

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"

    echo "Getting local K8s API"

    API_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
    API_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
    API_SERVER=$(echo $API_URL| cut -d ":" -f 2| tr -d '/')
    API_PORT=$(echo $API_URL| cut -d ":" -f 3)

    echo "            🌏 API URL:               $API_URL"
    echo "            🌏 API SERVER:            $API_SERVER"
    echo "            🌏 API PORT:              $API_PORT"
    echo "            🔐 API Token:             $API_TOKEN"

    echo ""
    echo "Creating OBSERVER"


    curl -k -X POST "$TOPO_ROUTE/1.0/kubernetes-observer/jobs/load" --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' --header 'Accept: application/json' -u $LOGIN --header "Content-Type: application/json" \
      -d "{
        \"unique_id\": \"demo-robot-shop\",
        \"type\": \"load\",
        \"description\": \"Automatically created by Nicks scripts\",
        \"parameters\": {
          \"data_center\": \"robot-shop\",
          \"master_ip\": \"$API_SERVER\",
          \"api_port\": \"$API_PORT\",
          \"token\": {
            \"hiddenString\": \"$API_TOKEN\",
            \"encrypted\": false
          },
          \"trust_all_certificate\": true,
          \"hide_terminated_pods\": false,
          \"connect_read_timeout_ms\": 5000,
          \"custom_resource_definitions\": [
            \"string\"
          ],
          \"role_token\": false,
          \"namespace\": \"robot-shop\",
          \"namespaceGroupParameters\": {
            \"correlate\": true
          }
        },
        \"schedule\": {
            \"interval\": null,
            \"units\": null,
            \"nextRunTime\": null
          },
        \"write_file_observer_file\": false,
        \"scheduleRequest\": true
      }"







# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# K8s OBSERVER  SOCK SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE K8S OBSERVER SOCK SHOP



    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    echo "Creating K8s Observer"


    # Create Route
    oc create route passthrough aiops-topology-kubernetes-observer -n $AIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-kubernetes-observer --port=https-kubernetes-observer-api

    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-kubernetes-observer -o jsonpath={.spec.host})

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"

    echo "Getting local K8s API"

    API_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
    API_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
    API_SERVER=$(echo $API_URL| cut -d ":" -f 2| tr -d '/')
    API_PORT=$(echo $API_URL| cut -d ":" -f 3)

    echo "            🌏 API URL:               $API_URL"
    echo "            🌏 API SERVER:            $API_SERVER"
    echo "            🌏 API PORT:              $API_PORT"
    echo "            🔐 API Token:             $API_TOKEN"

    echo ""
    echo "Creating OBSERVER"


    curl -k -X POST "$TOPO_ROUTE/1.0/kubernetes-observer/jobs/load" --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' --header 'Accept: application/json' -u $LOGIN --header "Content-Type: application/json" \
      -d "{
        \"unique_id\": \"demo-sock-shop\",
        \"type\": \"load\",
        \"description\": \"Automatically created by Nicks scripts\",
        \"parameters\": {
          \"data_center\": \"sock-shop\",
          \"master_ip\": \"$API_SERVER\",
          \"api_port\": \"$API_PORT\",
          \"token\": {
            \"hiddenString\": \"$API_TOKEN\",
            \"encrypted\": false
          },
          \"trust_all_certificate\": true,
          \"hide_terminated_pods\": false,
          \"connect_read_timeout_ms\": 5000,
          \"custom_resource_definitions\": [
            \"string\"
          ],
          \"role_token\": false,
          \"namespace\": \"sock-shop\",
          \"namespaceGroupParameters\": {
            \"correlate\": true
          }
        },
        \"schedule\": {
            \"interval\": null,
            \"units\": null,
            \"nextRunTime\": null
          },
        \"write_file_observer_file\": false,
        \"scheduleRequest\": true
      }"








# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# RULES
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------


# 🚀 TOPOLOGY - CREATE BUSINESS CRITICALITIES


        
    echo "Create CREATE BUSINESS CRITICALITIES"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

 
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

        
    curl -XPOST -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN \
    -d '    {

      "name": "Platinum",
      "keyIndexName": "aiopsBusinessCriticalityMetadata::platinum",
      "description": "Platinum priority",
      "entityTypes": [
        "AIOPS_BUSINESS_CRITICALITY"
      ],
      "businessCriticalityValue": 100,
      "tags": [
        "ASM_UI_CONFIG"
      ]
    }'


    curl -XPOST -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN \
    -d '    {

      "name": "Gold",
      "keyIndexName": "aiopsBusinessCriticalityMetadata::gold",
      "description": "Gold priority",
      "de   scription": "Gold priority",
      "entityTypes": [
        "AIOPS_BUSINESS_CRITICALITY"
      ],
      "businessCriticalityValue": 75,
      "tags": [
        "ASM_UI_CONFIG"
      ]
    }'

      curl -XPOST -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN \
    -d '    {

      "name": "Silver",
      "keyIndexName": "aiopsBusinessCriticalityMetadata::silver",
      "description": "Silver priority",
      "entityTypes": [
        "AIOPS_BUSINESS_CRITICALITY"
      ],
      "businessCriticalityValue": 50,
      "tags": [
        "ASM_UI_CONFIG"
      ]
    }'


    curl -XPOST -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN \
    -d '    {

      "name": "Bronze",
      "keyIndexName": "aiopsBusinessCriticalityMetadata::bronze",
      "description": "Bronze priority",
      "entityTypes": [
        "AIOPS_BUSINESS_CRITICALITY"
      ],
      "businessCriticalityValue": 25,
      "tags": [
        "ASM_UI_CONFIG"
      ]
    }'

    curl -XPOST -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN \
    -d '    {

      "name": "Bronze",
      "keyIndexName": "aiopsBusinessCriticalityMetadata::none",
      "description": "Lowes priority",
      "entityTypes": [
        "AIOPS_BUSINESS_CRITICALITY"
      ],
      "businessCriticalityValue": 1,
      "tags": [
        "ASM_UI_CONFIG"
      ]
    }'





# --------------------------------------------------------------------------------------------------------------------------------------
# AIOPS
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE MERGE RULES


    
    echo "Create Rules - Starting..."
    
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    #  topology-merge -n $AIOPS_NAMESPACE
    # oc create route passthrough topology-merge -n $AIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-merge --port=https-merge-api
    export MERGE_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-merge -o jsonpath={.spec.host})


    echo "    URL: $MERGE_ROUTE/1.0/merge/"
    echo "    LOGIN: $LOGIN"


    echo "  Wait 5 seconds"
    sleep 5

    echo "  Create Match RULE... MatchTokenDeployName"
    curl -X "POST" "$MERGE_ROUTE/1.0/merge/rules" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN \
        -d $'{
        "name": "MatchTokenDeployName",
        "ruleType": "matchTokensRule",
        "entityTypes": ["deployment"],
        "tokens": ["name"],
        "ruleStatus": "enabled",
        "observers": ["*"],
        "providers": ["*"]
    }'

    echo "  Create Merge RULE... MergeTokenDeployName"
    curl -X "POST" "$MERGE_ROUTE/1.0/merge/rules" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN \
        -d $'{
        "name": "MergeTokenDeployName",
        "ruleType": "mergeRule",
        "entityTypes": ["deployment","statefulset","container"],
        "tokens": ["name"],
        "ruleStatus": "enabled",
        "observers": ["*"],
        "providers": ["*"]
    }'

    echo "  Create Match RULE... MergeTokenDeployName"
    curl -X "POST" "$MERGE_ROUTE/1.0/merge/rules" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $LOGIN \
        -d $'{
        "name": "MatchTokenNetworkinterfacesID",
        "ruleType": "mergeRule",
        "entityTypes": ["networkinterface"],
        "tokens": ["uniqueId"],
        "ruleStatus": "enabled",
        "observers": ["*"],
        "providers": ["*"]
    }'

    echo "  Disable RULE k8ServiceName..."

    export RULE_ID=$(curl "$MERGE_ROUTE/1.0/merge/rules?ruleType=matchTokensRule&_filter=name=k8ServiceName&_include_count=false&_field=*" -s --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -u $LOGIN| jq -r "._items[0]._id")



    curl -XPUT "$MERGE_ROUTE/1.0/merge/rules/$RULE_ID" -s --insecure \
        --header 'Content-Type: application/json' \
        --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -u $LOGIN \
        -d '{
          "name": "k8ServiceName",
          "keyIndexName": "k8ServiceName",
          "ruleType": "matchTokensRule",
          "entityTypes": [
            "service"
          ],
          "tokens": [
            "name"
          ],
          "ruleStatus": "disabled",
          
          "observers": [
            "kubernetes-observer"
          ],
          "providers": [
            "*"
          ]
        }' 


    echo "  Disable RULE instana-observer-events-kubernetes-service..."

    export RULE_ID=$(curl "$MERGE_ROUTE/1.0/merge/rules?ruleType=matchTokensRule&_filter=name=instana-observer-events-kubernetes-service&_include_count=false&_field=*" -s --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -u $LOGIN| jq -r "._items[0]._id")



    curl -XPUT "$MERGE_ROUTE/1.0/merge/rules/$RULE_ID" -s --insecure \
        --header 'Content-Type: application/json' \
        --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -u $LOGIN \
        -d '{
          "name": "k8ServiceName",
          "keyIndexName": "k8ServiceName",
          "ruleType": "matchTokensRule",
          "entityTypes": [
            "service"
          ],
          "tokens": [
            "name"
          ],
          "ruleStatus": "disabled",
          
          "observers": [
            "kubernetes-observer"
          ],
          "providers": [
            "*"
          ]
        }' 






# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# LOAD TOPOLOGY CONFIGURATION
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - LOAD TOPOLOGY CONFIGURATION


    
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    # kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- /opt/ibm/graph.tools/bin/backup_ui_config -out backup.json
    # kubectl cp -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}'):/opt/ibm/netcool/asm/data/tools/backup.json ./backup.json
    # open ./backup.json



    echo "Delete existing Topology Customization"
    curl -XGET -k \
    "$TOPO_MGT_ROUTE/1.0/topology/metadata?_field=*" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -u $LOGIN|jq -r '._items[] | select(.maxLabelLength=="")|._id'>/tmp/customItems.json

    cat /tmp/customItems.json

    while read line; 
    do 
      echo "DELETE: $line"
      curl -XDELETE -k \
      "$TOPO_MGT_ROUTE/1.0/topology/metadata/$line" \
      -H 'accept: application/json' \
      -H 'content-type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -u $LOGIN
    done < /tmp/customItems.json



    echo "Upload Topology Customization"
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          TOPOLOGY_CUSTOM_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/asm_config.json"
    else
          TOPOLOGY_CUSTOM_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/topology/asm_config.json"
    fi    
    kubectl cp $TOPOLOGY_CUSTOM_FILE -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}'):/opt/ibm/netcool/asm/data/tools/asm_config.json 
    
    sleep 30 

    echo "Import Topology Customization"
    #kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- find /opt/ibm/netcool/asm/data/tools/
    kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- /opt/ibm/graph.tools/bin/import_ui_config -file asm_config.json






# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# FILE TOPOLOGY
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# FILE TOPOLOGY ROBOT SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - COPY OVERLAY TOPOLOGY TO POD ROBOTSHOP


    
    echo "Create Custom Topology - Copy Topology to File Observer"

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    echo $FILE_OBSERVER_POD
    LOAD_FILE_NAME="robot-shop-file.txt"
    
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          FILE_OBSERVER_CAP=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    else
          FILE_OBSERVER_CAP="./ansible/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    fi    
    echo $FILE_OBSERVER_POD
    echo $FILE_OBSERVER_CAP
    echo $TARGET_FILE_PATH
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    echo "  Copying capture file [${FILE_OBSERVER_CAP}] to file observer pod"
    echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
    oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}




# 🚀 TOPOLOGY - CREATE OVERLAY TOPOLOGY ROBOTSHOP


    
    echo "Create Custom Topology - Create File Observer Job"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    LOAD_FILE_NAME="robot-shop-file.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"



    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export JOB_ID=robot-shop-topology

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"


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



  





# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# FILE TOPOLOGY SOCK SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - COPY OVERLAY TOPOLOGY TO POD SOCKSHOP


    
    echo "Create Custom Topology - Copy Topology to File Observer"

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    echo $FILE_OBSERVER_POD
    LOAD_FILE_NAME="sock-shop-file.txt"
    
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          FILE_OBSERVER_CAP=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    else
          FILE_OBSERVER_CAP="./ansible/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    fi    
    echo $FILE_OBSERVER_POD
    echo $FILE_OBSERVER_CAP
    echo $TARGET_FILE_PATH
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    echo "  Copying capture file [${FILE_OBSERVER_CAP}] to file observer pod"
    echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
    oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}




# 🚀 TOPOLOGY - CREATE OVERLAY TOPOLOGY SOCKSHOP


    
    echo "Create Custom Topology - Create File Observer Job"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    LOAD_FILE_NAME="sock-shop-file.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"



    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export JOB_ID=sock-shop-topology

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"


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



  



# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# FILE TOPOLOGY ACME AIR
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - COPY OVERLAY TOPOLOGY TO POD ACME


    
    echo "Create Custom Topology - Copy Topology to File Observer"

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    echo $FILE_OBSERVER_POD
    LOAD_FILE_NAME="acme-file.txt"
    
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          FILE_OBSERVER_CAP=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    else
          FILE_OBSERVER_CAP="./ansible/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    fi    
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    echo $FILE_OBSERVER_POD
    echo $FILE_OBSERVER_CAP
    echo $TARGET_FILE_PATH
    echo "  Copying capture file [${FILE_OBSERVER_CAP}] to file observer pod"
    echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
    oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}






# 🚀 TOPOLOGY - CREATE OVERLAY TOPOLOGY ACME


    
    echo "Create Custom Topology - Create File Observer Job"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    LOAD_FILE_NAME="acme-file.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"



    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export JOB_ID=acme-topology

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"


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



  




# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# FILE TOPOLOGY TELCO
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - COPY OVERLAY TOPOLOGY TO POD TELCO


    
    echo "Create Custom Topology - Copy Topology to File Observer"

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    echo $FILE_OBSERVER_POD
    LOAD_FILE_NAME="telco-fiber-cut-ny-rchmd.txt"
    
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          FILE_OBSERVER_CAP=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    else
          FILE_OBSERVER_CAP="./ansible/roles/ibm-aiops-install-demo-content/templates/topology/$LOAD_FILE_NAME"
    fi    
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    echo $FILE_OBSERVER_POD
    echo $FILE_OBSERVER_CAP
    echo $TARGET_FILE_PATH
    echo "  Copying capture file [${FILE_OBSERVER_CAP}] to file observer pod"
    echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
    oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}






# 🚀 TOPOLOGY - CREATE OVERLAY TOPOLOGY TELCO


    
    echo "Create Custom Topology - Create File Observer Job"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    LOAD_FILE_NAME="telco-fiber-cut-ny-rchmd.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"



    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export JOB_ID=telco-fiber-cut-ny-rchmd-topology

    echo "  URL: $TOPO_ROUTE"
    echo "  LOGIN: $LOGIN"


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



  






# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# TEMPLATES
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# TEMPLATE ROBOT SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE TOPOLOGY TEMPLATES RobotShop


        
    echo "Create Custom Topology - Create Template"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

 
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Drobot-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Drobot-shop-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

    echo "    APP_ID: $APP_ID"
    echo "    TEMPLATE_ID: $TEMPLATE_ID"

    if [[ $TEMPLATE_ID == "" ]];
    then
      echo "  Create Template"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "robot-shop-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:robot-shop"
          ],
          "correlatable": "true",
          "name": "robot-shop-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "robot-shop-template"
          ]
      }'
    else
      echo "  Recreate Template"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

      
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "robot-shop-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:robot-shop"
          ],
          "correlatable": "true",
          "name": "robot-shop-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "robot-shop-template"
          ]
      }'

    fi

  








# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# TEMPLATE SOCK SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE TOPOLOGY TEMPLATES SOCK


        
    echo "Create Custom Topology - Create Template"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

 
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dsock-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dsock-shop-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

    echo "    APP_ID: $APP_ID"
    echo "    TEMPLATE_ID: $TEMPLATE_ID"

    if [[ $TEMPLATE_ID == "" ]];
    then
      echo "  Create Template"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "sock-shop-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:sock-shop"
          ],
          "correlatable": "true",
          "name": "sock-shop-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "sock-shop-template"
          ]
      }'
    else
      echo "  Recreate Template"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

      
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "sock-shop-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:sock-shop"
          ],
          "correlatable": "true",
          "name": "sock-shop-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "sock-shop-template"
          ]
      }'

    fi

  







# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# TEMPLATE ACME
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE TOPOLOGY TEMPLATES ACME


        
    echo "Create Custom Topology - Create Template"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

 
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dacme-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dacme-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

    echo "    APP_ID: $APP_ID"
    echo "    TEMPLATE_ID: $TEMPLATE_ID"

    if [[ $TEMPLATE_ID == "" ]];
    then
      echo "  Create Template"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "acme-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:acme"
          ],
          "correlatable": "true",
          "name": "acme-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "acme-template"
          ]
      }'
    else
      echo "  Recreate Template"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

      
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "acme-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "namespace:acme"
          ],
          "correlatable": "true",
          "name": "acme-template",
          "entityTypes": [
              "completeGroup",
              "namespace"
          ],
          "tags": [
              "acme-template"
          ]
      }'

    fi

  







# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# TEMPLATE TELCO
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - CREATE TOPOLOGY TEMPLATES TELCO


        
    echo "Create Custom Topology - Create Template"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    # oc create route passthrough topology-manage -n $AIOPS_NAMESPACE --service=aiops-topology-topology --port=https-topology-api
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

 
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Doptical-networks" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Doptical-networks-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

    echo "    APP_ID: $APP_ID"
    echo "    TEMPLATE_ID: $TEMPLATE_ID"

    if [[ $TEMPLATE_ID == "" ]];
    then
      echo "  Create Template"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "optical-networks-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "app:telco"
          ],
          "correlatable": "true",
          "name": "optical-networks-template",
          "entityTypes": [
              "completeGroup",
              "port",
              "device"
          ],
          "tags": [
              "optical-networks-template"
          ]
      }'
    else
      echo "  Recreate Template"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

      
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "optical-networks-template",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "groupTokens": [
              "app:telco"
          ],
          "correlatable": "true",
          "name": "optical-networks-template",
          "entityTypes": [
              "completeGroup",
              "port",
              "device"
          ],
          "tags": [
              "optical-networks-template"
          ]
      }'

    fi



# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION ROBOT SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - 🚀 CREATE APPLICATION ROBOT SHOP



    echo "Create Custom Topology - Add Members to App"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Drobot-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Drobot-shop-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_NET_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3Dnetwork-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .uniqueId == "robot-shop::kubernetes::namespace::robot-shop")|._id'| tail -1)
    #export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .keyIndexName == "robot-shop")|._id'| tail -1)

    echo "    APP_ID:     "$APP_ID
    echo "    TEMPLATE_ID:"$TEMPLATE_ID
    echo "    TEMPLATE_NET_ID:"$TEMPLATE_NET_ID
    echo "    K8S_OBS_ID: "$K8S_OBS_ID
 
    echo "Create Custom Topology - Create App"

    if [[ $APP_ID == "" ]];
    then    
      echo "  Creating Application"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "robot-shop-app",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Platinum",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "100",
          "name": "RobotShop",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:robotshop",
            "app:robot-shop"
          ]
      }'
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
          "keyIndexName": "robot-shop-app",
          "_correlationEnabled": "true",
          "iconId": "application",
          "businessCriticality": "Platinum",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "100",
          "name": "RobotShop",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:robotshop",
            "app:robot-shop"
          ]
      }'
    fi

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Drobot-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    if [[ $K8S_OBS_ID == "" ]];
    then  
      echo "    No K8s Observer defined"
    else
      echo "  Add K8s Observer Resources"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d "{
        \"_id\": \"$K8S_OBS_ID\"
      }"
    fi

    echo "  Add Template (File Observer) Resources"
    curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d "{
      \"_id\": \"$TEMPLATE_ID\"
    }"

    # echo "  Add Template (Network) Resources"
    # curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    # -u $LOGIN \
    # -H 'Content-Type: application/json' \
    # -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    # -d "{
    #   \"_id\": \"$TEMPLATE_NET_ID\"
    # }"

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # RE-RUN K8s Observer
    # # -------------------------------------------------------------------------------------------------------------------------------------------------

    export AIO_PLATFORM_ROUTE=$(oc get route -n $AIOPS_NAMESPACE aimanager-aio-controller -o jsonpath={.spec.host})

    echo "        Namespace:          $AIOPS_NAMESPACE"
    echo "        AIO_PLATFORM_ROUTE: $AIO_PLATFORM_ROUTE"
    echo ""

    echo "       🛠️   Getting ZEN Token"

    ZEN_API_HOST=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath='{.spec.host}')
    ZEN_LOGIN_URL="https://${ZEN_API_HOST}/v1/preauth/signin"
    LOGIN_USER=admin
    LOGIN_PASSWORD="$(oc get secret admin-user-details -n $AIOPS_NAMESPACE -o jsonpath='{ .data.initial_admin_password }' | base64 --decode)"

    ZEN_LOGIN_RESPONSE=$(
    curl -k \
    -H 'Content-Type: application/json' \
    -XPOST \
    "${ZEN_LOGIN_URL}" \
    -d '{
        "username": "'"${LOGIN_USER}"'",
        "password": "'"${LOGIN_PASSWORD}"'"
    }' 2> /dev/null
    )

    ZEN_LOGIN_MESSAGE=$(echo "${ZEN_LOGIN_RESPONSE}" | jq -r .message)

    if [ "${ZEN_LOGIN_MESSAGE}" != "success" ]; then
        echo "Login failed: ${ZEN_LOGIN_MESSAGE}"

    fi

    ZEN_TOKEN=$(echo "${ZEN_LOGIN_RESPONSE}" | jq -r .token)
    # echo "${ZEN_TOKEN}"


    echo "Getting local K8s API"

    API_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
    API_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
    API_SERVER=$(echo $API_URL| cut -d ":" -f 2| tr -d '/')
    API_PORT=$(echo $API_URL| cut -d ":" -f 3)

    echo "            🌏 API URL:               $API_URL"
    echo "            🌏 API SERVER:            $API_SERVER"
    echo "            🌏 API PORT:              $API_PORT"
    echo "            🔐 API Token:             $API_TOKEN"



    echo "Sucessfully logged in" 
    echo ""
    echo "Running K8S OBSERVER"

    curl -X 'POST' --insecure \
      "https://$AIO_PLATFORM_ROUTE/v1/observer/runjob/robot-shop" \
      -H 'accept: application/json' \
      -H 'Content-Type: application/json' \
      -H "authorization: Bearer $ZEN_TOKEN"  \


    # curl -X 'POST' --insecure \
    #   "https://$AIO_PLATFORM_ROUTE/v1/observer/runjob/robot-shop-topology" \
    #   -H 'accept: application/json' \
    #   -H 'Content-Type: application/json' \
    #   -H "authorization: Bearer $ZEN_TOKEN"  \












# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION SOCK SHOP
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - 🚀 CREATE APPLICATION SOCK SHOP



    echo "Create Custom Topology - Add Members to App"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dsock-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dsock-shop-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_NET_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3Dnetwork-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .uniqueId == "sock-shop::kubernetes::namespace::sock-shop")|._id'| tail -1)
    #export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .keyIndexName == "sock-shop")|._id'| tail -1)

    echo "    APP_ID:     "$APP_ID
    echo "    TEMPLATE_ID:"$TEMPLATE_ID
    echo "    TEMPLATE_NET_ID:"$TEMPLATE_NET_ID
    echo "    K8S_OBS_ID: "$K8S_OBS_ID
 
    echo "Create Custom Topology - Create App"

    if [[ $APP_ID == "" ]];
    then    
      echo "  Creating Application"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "sock-shop-app",
          "_correlationEnabled": "true",
          "iconId": "swarm",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "50",
          "name": "SockShop",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:sockshop",
            "app:sock-shop"
          ]
      }'
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
          "keyIndexName": "sock-shop-app",
          "_correlationEnabled": "true",
          "iconId": "swarm",
          "businessCriticality": "Gold",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "50",
          "name": "SockShop",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:sockshop",
            "app:sock-shop"
          ]
      }'
    fi

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dsock-shop-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # if [[ $K8S_OBS_ID == "" ]];
    # then  
    #   echo "    No K8s Observer defined"
    # else
    #   echo "  Add K8s Observer Resources"
    #   curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    #   -u $LOGIN \
    #   -H 'Content-Type: application/json' \
    #   -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    #   -d "{
    #     \"_id\": \"$K8S_OBS_ID\"
    #   }"
    # fi

    echo "  Add Template (File Observer) Resources"
    curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d "{
      \"_id\": \"$TEMPLATE_ID\"
    }"


    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # RE-RUN K8s Observer
    # # -------------------------------------------------------------------------------------------------------------------------------------------------

    export AIO_PLATFORM_ROUTE=$(oc get route -n $AIOPS_NAMESPACE aimanager-aio-controller -o jsonpath={.spec.host})

    echo "        Namespace:          $AIOPS_NAMESPACE"
    echo "        AIO_PLATFORM_ROUTE: $AIO_PLATFORM_ROUTE"
    echo ""

    echo "       🛠️   Getting ZEN Token"

    ZEN_API_HOST=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath='{.spec.host}')
    ZEN_LOGIN_URL="https://${ZEN_API_HOST}/v1/preauth/signin"
    LOGIN_USER=admin
    LOGIN_PASSWORD="$(oc get secret admin-user-details -n $AIOPS_NAMESPACE -o jsonpath='{ .data.initial_admin_password }' | base64 --decode)"

    ZEN_LOGIN_RESPONSE=$(
    curl -k \
    -H 'Content-Type: application/json' \
    -XPOST \
    "${ZEN_LOGIN_URL}" \
    -d '{
        "username": "'"${LOGIN_USER}"'",
        "password": "'"${LOGIN_PASSWORD}"'"
    }' 2> /dev/null
    )

    ZEN_LOGIN_MESSAGE=$(echo "${ZEN_LOGIN_RESPONSE}" | jq -r .message)

    if [ "${ZEN_LOGIN_MESSAGE}" != "success" ]; then
        echo "Login failed: ${ZEN_LOGIN_MESSAGE}"

    fi

    ZEN_TOKEN=$(echo "${ZEN_LOGIN_RESPONSE}" | jq -r .token)
    # echo "${ZEN_TOKEN}"


    echo "Getting local K8s API"

    API_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
    API_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
    API_SERVER=$(echo $API_URL| cut -d ":" -f 2| tr -d '/')
    API_PORT=$(echo $API_URL| cut -d ":" -f 3)

    echo "            🌏 API URL:               $API_URL"
    echo "            🌏 API SERVER:            $API_SERVER"
    echo "            🌏 API PORT:              $API_PORT"
    echo "            🔐 API Token:             $API_TOKEN"



    echo "Sucessfully logged in" 
    echo ""
    echo "Running K8S OBSERVER"

    curl -X 'POST' --insecure \
      "https://$AIO_PLATFORM_ROUTE/v1/observer/runjob/sock-shop" \
      -H 'accept: application/json' \
      -H 'Content-Type: application/json' \
      -H "authorization: Bearer $ZEN_TOKEN"  \


    # curl -X 'POST' --insecure \
    #   "https://$AIO_PLATFORM_ROUTE/v1/observer/runjob/sock-shop-topology" \
    #   -H 'accept: application/json' \
    #   -H 'Content-Type: application/json' \
    #   -H "authorization: Bearer $ZEN_TOKEN"  \










# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION ACME AIR
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - 🚀 CREATE APPLICATION ACME



    echo "Create Custom Topology - Add Members to App"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dacme-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dacme-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_NET_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=name%3Dnetwork-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .keyIndexName == "acme::kubernetes::namespace::acme")|._id'| tail -1)
    #export K8S_OBS_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]| select( .keyIndexName == "acme")|._id'| tail -1)

    echo "    APP_ID:     "$APP_ID
    echo "    TEMPLATE_ID:"$TEMPLATE_ID
    echo "    TEMPLATE_NET_ID:"$TEMPLATE_NET_ID
    echo "    K8S_OBS_ID: "$K8S_OBS_ID
 
    echo "Create Custom Topology - Create App"

    if [[ $APP_ID == "" ]];
    then    
      echo "  Creating Application"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "acme-app",
          "_correlationEnabled": "true",
          "iconId": "cluster",
          "businessCriticality": "Silver",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "25",
          "name": "ACME Air",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:acmeair",
            "app:acme-air"
          ]
      }'
    else
      echo "  Application already exists"
      echo "  Re-Creating Application"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'


      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "acme-app",
          "_correlationEnabled": "true",
          "iconId": "cluster",
          "businessCriticality": "Silver",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "25",
          "name": "ACME Air",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:acmeair",
            "app:acme-air"
          ]
      }'

    fi

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dacme-app" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------


    echo "  Add Template (File Observer) Resources"
    curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d "{
      \"_id\": \"$TEMPLATE_ID\"
    }"










# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION TELCO
# --------------------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------------------
# 🚀 TOPOLOGY - 🚀 CREATE APPLICATION TELCO



    echo "Create Custom Topology - Add Members to App"


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Doptical-networks" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Doptical-networks-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID
    echo "    TEMPLATE_ID:"$TEMPLATE_ID
    echo "Create Custom Topology - Create App"

    if [[ $APP_ID == "" ]];
    then    
      echo "  Creating Application"
      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "optical-networks",
          "_correlationEnabled": "true",
          "iconId": "cluster",
          "businessCriticality": "Platinum",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "1000",
          "name": "Optical Networks",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:optical-networks",
            "app:telco"
          ]
      }'
    else
      echo "  Application already exists"
      echo "  Re-Creating Application"
      curl -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'


      curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
      -u $LOGIN \
      -H 'Content-Type: application/json' \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -d '  {
          "keyIndexName": "optical-networks",
          "_correlationEnabled": "true",
          "iconId": "cluster",
          "businessCriticality": "Platinum",
          "vertexType": "group",
          "correlatable": "true",
          "disruptionCostPerMin": "1000",
          "name": "Optical Networks",
          "entityTypes": [
              "waiopsApplication"
          ],
          "tags": [
            "app:optical-networks",
            "app:telco"
          ]
      }'

    fi

    export APP_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Doptical-networks" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------


    echo "  Add Template (File Observer) Resources"
    curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d "{
      \"_id\": \"$TEMPLATE_ID\"
    }"



