

# Restart Spark
oc delete pod  -n ibm-aiops --ignore-not-found $(oc get po -n ibm-aiops|grep spark|awk '{print$1}') --force --grace-period=0
oc delete pod  -n ibm-aiops --ignore-not-found $(oc get po -n ibm-aiops|grep metric|awk '{print$1}') --force --grace-period=0

# STUCK TRAINING

oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/MetricAnomaly
oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/MetricAnomaly



oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/metric_anomaly_detection_configuration




oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/TemporalGrouping
oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/TemporalGrouping


oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/alert_seasonality_detection_configuration
oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/alert_x_in_y_supression_configuration
oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/alert_seasonality_detection_configuration
oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/alert_x_in_y_supression_configuration


oc rsh -n ibm-aiops $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X GET -E trainingdefinition/_doc/




oc get pods -n ibm-aiops -l release=aiops-topology




export CASSANDRA_PASS=$(oc get secret aiops-topology-cassandra-auth-secret -n ibm-aiops -o jsonpath='{.data.password}' | base64 -d)
export CASSANDRA_USER=$(oc get secret aiops-topology-cassandra-auth-secret -n ibm-aiops -o jsonpath='{.data.username}' | base64 -d)

echo "CASSANDRA_USER:$CASSANDRA_USER"
echo "CASSANDRA_PASS:$CASSANDRA_PASS"

oc exec -n ibm-aiops -it aiops-topology-cassandra-0 -- bash



cqlsh --ssl -u admin --request-timeout=17200



SELECT * FROM tararam.md_metric_resource;