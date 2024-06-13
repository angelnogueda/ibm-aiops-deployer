#!/bin/bash
echo "***************************************************************************************************************************************"




export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

oc project $AIOPS_NAMESPACE >/dev/null 2>/dev/null

echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🔎  Get Cassandra Authentication"	
echo "   ------------------------------------------------------------------------------------------------------------------------------"
export CASSANDRA_PASS=$(oc get secret aiops-topology-cassandra-auth-secret -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 -d)
export CASSANDRA_USER=$(oc get secret aiops-topology-cassandra-auth-secret -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 -d)

echo "CASSANDRA_USER:$CASSANDRA_USER"
echo "CASSANDRA_PASS:$CASSANDRA_PASS"


echo  ""    
echo  ""
echo "     --------------------------------------------------------------------------------------------"
echo "     💾 Dump the tables to the Pod filesystem"

oc exec -ti aiops-topology-cassandra-0 -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASSANDRA_USER -p $CASSANDRA_PASS -e \"copy aiops.alerts to '/tmp/aiops.alerts.csv' with header=true;\""


echo  ""    
echo  ""
echo "     --------------------------------------------------------------------------------------------"
echo "     📥 Copy the dumps from the Pod to the local filesystem (you can ignore rsync errors)"

oc rsync aiops-topology-cassandra-0:/tmp/aiops.alerts.csv $(pwd)


