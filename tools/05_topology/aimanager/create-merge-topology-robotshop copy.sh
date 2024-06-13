echo "Create Custom Topology - Starting..."
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')



export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)


export REST_TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-rest-observer -o jsonpath={.spec.host})
export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})


export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

echo "URL: $TOPO_ROUTE/1.0/topology/swagger"
echo "USR: $TOPOLOGY_REST_USR"
echo "PWD: $TOPOLOGY_REST_PWD"
echo "TENANT ID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255"

echo "URL: $REST_TOPO_ROUTE/1.0/rest-observer/rest/resources"
echo "LOGIN: $LOGIN"


#echo curl -X "POST" "$TOPO_ROUTE/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: restTopology' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "robotshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["web"],"matchTokens": ["web","web-deployment"],"name": "web","namespace": "robot-shop","readyReplicas": 1,"tags": ["app:robotshop","namespace:robot-shop"],"vertexType": "resource","uniqueId": "web-id"}'



# -------------------------------------------------------------------------------------------------------------------------------------------------
# CREATE EDGES
# -------------------------------------------------------------------------------------------------------------------------------------------------
curl -k -X 'GET' \
  'https://topology-manage-ibm-aiops.apps.664c9df0dbc10e001e9ab754.cloud.techzone.ibm.com/1.0/topology/resources?_filter=tags%3Awesteurope&_field=*&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false' \
  -H 'accept: application/json' \
  -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
  -H 'authorization: Basic yyyyyy='