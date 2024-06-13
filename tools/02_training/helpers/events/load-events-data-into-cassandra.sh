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
echo "     💾 Copy files to Pod filesystem (you can ignore rsync not available in container)"
oc exec -ti aiops-topology-cassandra-0 -- bash -c "rm /tmp/aiops.alerts.csv"
#ls -1 $WORKING_DIR_OUTPUT
oc cp -n $AIOPS_NAMESPACE ./tools/02_training/helpers/events/data/aiops.alerts.csv aiops-topology-cassandra-0:/tmp/aiops.alerts.csv


echo  ""    
echo  ""
echo "     --------------------------------------------------------------------------------------------"
echo "     🧻 Empty the tables"
oc exec -ti aiops-topology-cassandra-0 -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASSANDRA_USER -p $CASSANDRA_PASS -e \"TRUNCATE  aiops.alerts;\""


echo  ""    
echo  ""
echo "     --------------------------------------------------------------------------------------------"
echo "     📥 Load the dumps"
oc exec -ti aiops-topology-cassandra-0 -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASSANDRA_USER -p $CASSANDRA_PASS -e \"copy aiops.alerts from '/tmp/aiops.alerts.csv' with header=true;\""



echo  ""    
echo  ""
echo "     --------------------------------------------------------------------------------------------"
echo "     🔎 Check the data"
oc exec -ti aiops-topology-cassandra-0 -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASSANDRA_USER -p $CASSANDRA_PASS -e \"SELECT COUNT(*) FROM aiops.alerts;\""


