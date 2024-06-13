clear 
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

oc project $AIOPS_NAMESPACE >/dev/null 2>/dev/null

echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🔎  Get Cassandra Authentication"	
echo "   ------------------------------------------------------------------------------------------------------------------------------"
export CASSANDRA_PASS=$(oc get secret aiops-topology-cassandra-auth-secret -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 -d)
export CASSANDRA_USER=$(oc get secret aiops-topology-cassandra-auth-secret -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 -d)

echo "           CASSANDRA USER:$CASSANDRA_USER"
echo "           CASSANDRA PASS:$CASSANDRA_PASS"


echo  ""    
echo  ""
echo "--------------------------------------------------------------------------------------------"
echo "💾 LAGS Metrics Count:"

echo "   🟣🟣🟣🟣: "$(oc exec -ti aiops-topology-cassandra-0 -c aiops-topology-cassandra -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASSANDRA_USER -p $CASSANDRA_PASS -e \"SELECT * FROM tararam.md_metric_resource;\""| grep "log_template_"|wc -l)

echo  ""    
echo  ""
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🔎  Get ES Authentication"	
echo "   ------------------------------------------------------------------------------------------------------------------------------"

export username=$(oc exec -c elasticsearch -n $AIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/username')	
export password=$(oc exec -c elasticsearch -n $AIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/password')	


echo "           ES User        : $username"
echo "           ES Password    : $password"
echo "  "


echo  ""    
echo  ""
echo "--------------------------------------------------------------------------------------------"
echo "💾 LAGS ES Index 1000-1000-la_golden_signals-models Count:"

echo "   🟣🟣🟣🟣: "$(curl -k -s -u $username:$password -XGET https://localhost:9200/1000-1000-la_golden_signals-models/_count| jq .count)



echo  ""    
echo  ""
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------"
echo  ""    
echo  ""
echo  ""    
echo  ""
