

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

export MYSQL_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name%3Dmysql&_filter=entityTypes%3Ddeployment&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
echo $MYSQL_ID

export result=$(curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$MYSQL_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"innodb_buffer_pool_size": "1GB"}')
echo $result


export result=$(curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$MYSQL_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"innodb_buffer_pool_size": "8GB"}')
echo $result


if (asmProperties.name == "mysql" && asmProperties.innodb_buffer_pool_size){
  return asmProperties.namespace+'.'+asmProperties.name+' : '+asmProperties.innodb_buffer_pool_size;
}
else
{
  return asmProperties.namespace+'.'+asmProperties.name;
}




# Label function
if (asmProperties.name == "mysql" && asmProperties.innodb_buffer_pool_size){
  return asmProperties.name+' : '+asmProperties.innodb_buffer_pool_size;
}
else
{
  return asmProperties.name;
}


# Border color function
if (asmProperties.name == "mysql" && asmProperties.innodb_buffer_pool_size != "8GB"){
  return '#882222';
}
else
{
  return '#aaaaaa';
}



# Background color function


if (asmProperties.name == "mysql" && asmProperties.innodb_buffer_pool_size != "8GB"){
  return '#ff6b7f';
}
else
{
  return '#c9ffd0';
}

