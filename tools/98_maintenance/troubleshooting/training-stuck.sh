export WAIOPS_NAMESPACE=$(oc get po -A|grep aimanager-operator |awk '{print$1}')

export ES_ROUTE=`oc get route -n $WAIOPS_NAMESPACE iaf-system-es -o jsonpath={.spec.host}`
export ES_USERNAME=$(oc exec -n $WAIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/username')	
export ES_PASSWORD=$(oc exec -n $WAIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/password')	

echo $ES_ROUTE
echo $ES_USERNAME
echo $ES_PASSWORD

curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/trainingstatus/_delete_by_query -d '{"query": {"match": {"name":"MetricAnomaly"}}}'
curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/trainingsrunning/_delete_by_query -d '{"query": {"match": {"algorithmName":"Metric_Anomaly_Detection"}}}'



curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/trainingstatus/_delete_by_query -d '{"query": {"match": {"name":"TemporalGrouping"}}}'
curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/trainingsrunning/_delete_by_query -d '{"query": {"match": {"algorithmName":"Temporal_Grouping"}}}'


# curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XPOST https://$ES_ROUTE/trainingdefinition/_delete_by_query -d '{"query": {"match": {"definitionName":"MetricAnomaly"}}}'
# oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X GET -E trainingsrunning/_doc




curl -s -k -u $ES_USERNAME:$ES_PASSWORD -H "Content-Type: application/json" -XGET https://$ES_ROUTE/'
































export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

usr=$(cat "$ELASTIC_SECRET_PATH/username")
pwd=$(cat "$ELASTIC_SECRET_PATH/password")

endpoint="$ES_URL/trainingstatus/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "name":"MetricAnomaly"
    }
  }
}'






oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/MetricAnomaly






oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/MetricAnomaly


oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/metric_anomaly_detection_configuration




oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/TemporalGrouping
oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/TemporalGrouping


oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/alert_seasonality_detection_configuration
oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/alert_x_in_y_supression_configuration
oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/alert_seasonality_detection_configuration
oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/alert_x_in_y_supression_configuration


oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X GET -E trainingdefinition/_doc/


oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}')  

./elastic.sh -X DELETE -E trainingdefinition/_doc/MetricAnomaly
./elastic.sh -X DELETE -E trainingdefinition/_doc/TemporalGrouping



<<comment
This script can be used on production envs to easily curl
Elastic and not have to constantly get the username/password combination
comment

while getopts X:E: flag
do
    case "${flag}" in
        X) type=${OPTARG};;
        E) endpoint="$ES_URL/${OPTARG}";;
    esac
done










oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/log_anomaly_golden_signal_configuration
oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingdefinition/_doc/metric_anomaly_detection_configuration


oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}') ./elastic.sh -X DELETE -E trainingstatus/_doc/metric_anomaly_detection_configuration





oc rsh -n $AIOPS_NAMESPACE $(oc get po -n ibm-aiops|grep aimanager-aio-ai-platform-api-server|awk '{print$1}')  



usr=$(cat "$ELASTIC_SECRET_PATH/username")
pwd=$(cat "$ELASTIC_SECRET_PATH/password")


endpoint="$ES_URL/trainingstatus/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "name":"MetricAnomaly"
    }
  }
}'


endpoint="$ES_URL/postchecktrainingdetails/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "definitionName":"MetricAnomaly"
    }
  }
}'



endpoint="$ES_URL/precheckrun/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "definitionName":"MetricAnomaly"
    }
  }
}'


endpoint="$ES_URL/prechecktrainingdetails/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "definitionName":"MetricAnomaly"
    }
  }
}'


endpoint="$ES_URL/trainingrun/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "definitionName":"MetricAnomaly"
    }
  }
}'


endpoint="$ES_URL/trainingsrunning/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "definitionName":"MetricAnomaly"
    }
  }
}'


endpoint="$ES_URL/trainingstatus/_delete_by_query"
curl -XPOST -k -u $usr:$pwd $endpoint -H 'Content-Type: application/json' -d '
{
  "query": {
    "match": {
      "name":"MetricAnomaly"
    }
  }
}'


