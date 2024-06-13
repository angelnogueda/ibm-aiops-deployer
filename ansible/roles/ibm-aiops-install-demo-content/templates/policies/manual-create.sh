

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    export POLICY_USERNAME=$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-lifecycle-policy-registry-svc -o jsonpath='{.data.username}' | base64 --decode)
    export POLICY_PASSWORD=$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-lifecycle-policy-registry-svc -o jsonpath='{.data.password}' | base64 --decode)
    export POLICY_LOGIN="$POLICY_USERNAME:$POLICY_PASSWORD"
    echo $POLICY_LOGIN

    oc create route passthrough --insecure-policy="Redirect" policy-api -n $AIOPS_NAMESPACE --service aiops-ir-lifecycle-policy-registry-svc --port ssl-port

    export POLICY_ROUTE=$(oc get routes -n $AIOPS_NAMESPACE policy-api -o jsonpath="{['spec']['host']}")
    echo $POLICY_ROUTE


    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ALL - DISABLED

    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json

    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - all alerts"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result




    
    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ROBOT SHOP
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-robot.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - robot-shop"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result


    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # SOCK SHOP
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-sock.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - sock-shop"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result


    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ACME
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-acme.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - acme"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result


    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ROBOT TELCO
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-telco.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - telco"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result


    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ROBOT TUBE
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-tube.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - tube"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result



    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # ROBOT CATCHALL
    export POLICY_FILE="./ansible/roles/ibm-aiops-install-demo-content/templates/policies/incident-creation-policy-catchall.json"
    echo $POLICY_FILE
    cp $POLICY_FILE /tmp/incident_policy.json


    export result=$(curl -XGET -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/"  \
      -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
      -H 'content-type: application/json' \
      -u $POLICY_LOGIN|grep "DEMO Incident - catchall"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then
      export result="Create Incident Creation Policy "
      export result=$(curl -XPOST -k -s "https://$POLICY_ROUTE/policyregistry.ibm-netcool-prod.aiops.io/v1alpha/system/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/policies"  \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H 'content-type: application/json' \
        -u $POLICY_LOGIN \
        -d @/tmp/incident_policy.json)
    else 
      export result="Already exists"
    fi 
    echo $result
