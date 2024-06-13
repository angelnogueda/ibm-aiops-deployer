release=aiops
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


# Scale down the core services which access the storage
oc scale deploy $release-topology-inventory --replicas=0
oc scale deploy $release-topology-topology --replicas=0
oc scale deploy $release-topology-layout --replicas=0
oc scale deploy $release-topology-merge --replicas=0
oc scale deploy $release-topology-status --replicas=0
oc scale deploy $release-ir-analytics-probablecause --replicas=0


# Retrieve the cassandra user and password from the OCP secret
export CASS_USER=$(oc get secret -n $AIOPS_NAMESPACE $release-topology-cassandra-auth-secret -o jsonpath='{.data.username}' | base64 -d)
export CASS_PASS=$(oc get secret -n $AIOPS_NAMESPACE $release-topology-cassandra-auth-secret -o jsonpath='{.data.password}' | base64 -d)

echo "CASS_USER:$CASS_USER"
echo "CASS_PASS:$CASS_PASS"


# Drop the topology janusgraph keyspace.
oc exec -ti aiops-topology-cassandra-0 -n $AIOPS_NAMESPACE -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASS_USER -p $CASS_PASS -e \"DROP KEYSPACE janusgraph;\""
oc exec -ti aiops-topology-cassandra-0 -n $AIOPS_NAMESPACE -- bash -c "/opt/ibm/cassandra/bin/cqlsh --ssl -u $CASS_USER -p $CASS_PASS -e \"DROP KEYSPACE janusgraph;\""

sleep 10

PGPASSWORD=$(oc get secret aiops-topology-postgres-user -o jsonpath="{.data.password}"| base64 --decode)


# Clear out the inventory data
oc exec -it $AIOPS_NAMESPACE-edb-postgres-1 -n $AIOPS_NAMESPACE -- /bin/bash -c 'export PGPASSWORD='$PGPASSWORD' && psql --host localhost --username aiops_topology_user --dbname aiops_topology --command "DO \
\$\$ \
BEGIN \
    EXECUTE (SELECT '\''TRUNCATE TABLE '\'' \
        || string_agg(format('\''%I.%I'\'', schemaname, tablename), '\'', '\'') \
        || '\'' CASCADE'\'' \
    FROM   pg_tables \
    WHERE    schemaname = '\''public'\'' \
    AND NOT tablename = '\''flyway_schema_history'\'' \
    ); \
END \
\$\$;"'

sleep 30

# Scale the core services back up
oc scale deploy $release-topology-inventory --replicas=1
oc scale deploy $release-topology-topology --replicas=1
oc scale deploy $release-topology-layout --replicas=1
oc scale deploy $release-topology-merge --replicas=1
oc scale deploy $release-topology-status --replicas=1
oc scale deploy $release-ir-analytics-probablecause --replicas=1

echo "waiting for a while for pods to start up"
sleep 120


while [ `oc get pod -n $AIOPS_NAMESPACE|egrep "topology|cassandra|probable"|grep "0/"|grep -v "Completed"| grep -c ""` -gt 0 ]
do
    echo "Waiting for Topology Pods"
    sleep 15
done
