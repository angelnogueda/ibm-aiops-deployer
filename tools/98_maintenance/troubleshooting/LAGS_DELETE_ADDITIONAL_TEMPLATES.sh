export WAIOPS_NAMESPACE=$(oc get po -A|grep aimanager-operator |awk '{print$1}')

export ES_ROUTE=`oc get route -n $WAIOPS_NAMESPACE iaf-system-es -o jsonpath={.spec.host}`
export ES_USERNAME=$(oc exec -n $WAIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/username')	
export ES_PASSWORD=$(oc exec -n $WAIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/password')	

echo $ES_ROUTE
echo $ES_USERNAME
echo $ES_PASSWORD

curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/1000-1000-la_golden_signals-models/_delete_by_query -d '{"query": {"range": {"template_id": {"gte" : 782}}}}'
