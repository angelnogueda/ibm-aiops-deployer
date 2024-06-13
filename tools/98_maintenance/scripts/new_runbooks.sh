
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
ZEN_API_HOST=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath='{.spec.host}')
ZEN_LOGIN_URL="https://${ZEN_API_HOST}/v1/preauth/signin"
LOGIN_USER=admin
LOGIN_PASSWORD="$(oc get secret admin-user-details -n $AIOPS_NAMESPACE -o jsonpath='{ .data.initial_admin_password }' | base64 --decode)"

ZEN_LOGIN_RESPONSE=$(
curl -k \
-H 'Content-Type: application/json' \
-XPOST \
"${ZEN_LOGIN_URL}" \
-d '{
      "username": "'"${LOGIN_USER}"'",
      "password": "'"${LOGIN_PASSWORD}"'"
}' 2> /dev/null
)

ZEN_TOKEN=$(echo "${ZEN_LOGIN_RESPONSE}" | jq -r .token)
echo $ZEN_TOKEN
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export DEMOUI_ROUTE=$(oc get route -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui -o jsonpath={.spec.host})
export DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
export DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')



export result=$(curl -X "GET" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
    -H "Authorization: bearer $ZEN_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8'|grep "Clear All Incidents"|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then


  export PAYLOAD=$(echo "    {
  \"name\": \"🚀 DEMO - Clear All Incidents\",
  \"description\": \"Clear All Incidents from the system.\",
  \"prerequisites\": \"\",
  \"parameters\": [],
  \"tags\": [],
  \"http\": {
    \"host\": \"https://$DEMOUI_ROUTE/injectRESTHeadless?app=clean\",
    \"method\": \"GET\",
    \"headers\": \"{}\",
    \"ignoreCertErrors\": false
  }
  }")

  echo $PAYLOAD>/tmp/action.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/actions?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/action.json)
  echo $result
  rm /tmp/action.json

  export actionID=$(echo $result|jq -r ._actionId)

  echo "actionID: $actionID"

  export PAYLOAD=$(echo "{
          \"tags\": [],
          \"steps\": [
            {
              \"number\": 1,
              \"title\": \"Clear All Incidents\",
              \"automationId\": \"$actionID\",
              \"type\": \"automation\"
            }
          ],
          \"name\": \"✅ Clear All Incidents\",
          \"description\": \"Clear All Incidents from the system\",
          \"parameters\": []
      }")
  echo $result
  echo $PAYLOAD>/tmp/runbook.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/runbook.json)


  rm /tmp/runbook.json
else 
  echo "Already exists"
fi 






    export result=$(curl -X "GET" -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
        -H "Authorization: bearer $ZEN_TOKEN" \
        -H 'Content-Type: application/json; charset=utf-8'|grep "Mitigate RobotShop Problem"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then

      export PAYLOAD=$(echo "{
              \"tags\": [],
              \"steps\": [
                {
                  \"mappings\": [
                    {
                      \"parameterMappingType\": \"parameter\",
                      \"parameterValue\": \"clusterCredentials\",
                      \"automationParameterName\": \"extraVariables\"
                    }
                  ],
                  \"number\": 1,
                  \"title\": \"\",
                  \"automationId\": \"AWX:job:IBM AIOPS Mitigate Robotshop Ratings Outage\",
                  \"type\": \"automation\"
                }
              ],
              \"name\": \"✅ Clear RobotShop Incident\",
              \"description\": \"Mitigate RobotShop Problem Incident\",
              \"parameters\": [
                {
                  \"minLength\": 0,
                  \"format\": \"multiline\",
                  \"name\": \"clusterCredentials\",
                        \"default\": \"{ \\\"my_k8s_apiurl\\\": \\\"$DEMO_URL\\\", \\\"my_k8s_apikey\\\": \\\"$DEMO_TOKEN\\\" }\",
                  \"description\": \"Cluster Credentials encoded as JSON..\",
                  \"type\": \"string\"
                }
              ]
          }")

      echo $PAYLOAD>/tmp/runbook.json

      
      export result=$(curl -X "POST" -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
          -H "Authorization: bearer $ZEN_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d @/tmp/runbook.json)


      rm /tmp/runbook.json
    else 
      export result="Already exists"
    fi 


    echo "$result"






    export result=$(curl -X "GET" -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
        -H "Authorization: bearer $ZEN_TOKEN" \
        -H 'Content-Type: application/json; charset=utf-8'|grep "IBM AIOPS Mitigate SockShop Switch Outage"|wc -l|tr -d ' ')

    if [[ $result == "0" ]]; then

      export PAYLOAD=$(echo "{
              \"tags\": [],
              \"steps\": [
                {
                  \"mappings\": [
                    {
                      \"parameterMappingType\": \"parameter\",
                      \"parameterValue\": \"clusterCredentials\",
                      \"automationParameterName\": \"extraVariables\"
                    }
                  ],
                  \"number\": 1,
                  \"title\": \"\",
                  \"automationId\": \"AWX:job:IBM AIOPS Mitigate SockShop Switch Outage\",
                  \"type\": \"automation\"
                }
              ],
              \"name\": \"✅ Clear SockShop Switch Incident\",
              \"description\": \"Mitigate SockShop Switch Outage Incident.\",
              \"parameters\": [
                {
                  \"minLength\": 0,
                  \"format\": \"multiline\",
                  \"name\": \"clusterCredentials\",
                        \"default\": \"{ \\\"my_k8s_apiurl\\\": \\\"$DEMO_URL\\\", \\\"my_k8s_apikey\\\": \\\"$DEMO_TOKEN\\\" }\",
                  \"description\": \"Cluster Credentials encoded as JSON..\",
                  \"type\": \"string\"
                }
              ]
          }")

      echo $PAYLOAD>/tmp/runbook.json

      
      export result=$(curl -X "POST" -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
          -H "Authorization: bearer $ZEN_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d @/tmp/runbook.json)


      rm /tmp/runbook.json
    else 
      export result="Already exists"
    fi 


    echo "$result"








export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export DEMOUI_ROUTE=$(oc get route -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui -o jsonpath={.spec.host})
export DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
export DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')



export result=$(curl -X "GET" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
    -H "Authorization: bearer $ZEN_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8'|grep "Create RobotShop Incident"|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then


  export PAYLOAD=$(echo "    {
  \"name\": \"🚀 DEMO - Create Incident RobotShop\",
  \"description\": \"Create Incident simulating a Git Commit for the Robotshop Application.\",
  \"prerequisites\": \"\",
  \"parameters\": [],
  \"tags\": [],
  \"http\": {
    \"host\": \"https://$DEMOUI_ROUTE/injectRESTHeadless?app=robotshop\",
    \"method\": \"GET\",
    \"headers\": \"{}\",
    \"ignoreCertErrors\": false
  }
  }")

  echo $PAYLOAD>/tmp/action.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/actions?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/action.json)
  echo $result
  rm /tmp/action.json

  export actionID=$(echo $result|jq -r ._actionId)

  echo "actionID: $actionID"

  export PAYLOAD=$(echo "{
          \"tags\": [],
          \"steps\": [
            {
              \"number\": 1,
              \"title\": \"Create Incident RobotShop\",
              \"automationId\": \"$actionID\",
              \"type\": \"automation\"
            }
          ],
          \"name\": \"🧨 Create RobotShop Incident\",
          \"description\": \"Create Incident simulating a Git Commit for the Robotshop Application.\",
          \"parameters\": []
      }")
  echo $result
  echo $PAYLOAD>/tmp/runbook.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/runbook.json)


  rm /tmp/runbook.json
else 
  echo "Already exists"
fi 


export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export DEMOUI_ROUTE=$(oc get route -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui -o jsonpath={.spec.host})
export DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
export DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')



export result=$(curl -X "GET" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
    -H "Authorization: bearer $ZEN_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8'|grep "Create SockShop Incident"|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then


  export PAYLOAD=$(echo "    {
  \"name\": \"🚀 DEMO - Create Incident SockShop\",
  \"description\": \"Create Incident simulating a Datacenter Switch Failure leading to the Catalogue DB Pod being unavailable.\",
  \"prerequisites\": \"\",
  \"parameters\": [],
  \"tags\": [],
  \"http\": {
    \"host\": \"https://$DEMOUI_ROUTE/injectRESTHeadless?app=sockshop\",
    \"method\": \"GET\",
    \"headers\": \"{}\",
    \"ignoreCertErrors\": false
  }
  }")

  echo $PAYLOAD>/tmp/action.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/actions?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/action.json)
  echo $result
  rm /tmp/action.json

  export actionID=$(echo $result|jq -r ._actionId)

  echo "actionID: $actionID"

  export PAYLOAD=$(echo "{
          \"tags\": [],
          \"steps\": [
            {
              \"number\": 1,
              \"title\": \"Create Incident SockShop\",
              \"automationId\": \"$actionID\",
              \"type\": \"automation\"
            }
          ],
          \"name\": \"🧨 Create SockShop Incident\",
          \"description\": \"Create Incident simulating a Datacenter Switch Failure leading to the Catalogue DB Pod being unavailable.\",
          \"parameters\": []
      }")
  echo $result
  echo $PAYLOAD>/tmp/runbook.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/runbook.json)


  rm /tmp/runbook.json
else 
  echo "Already exists"
fi 


export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export DEMOUI_ROUTE=$(oc get route -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui -o jsonpath={.spec.host})
export DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
export DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')



export result=$(curl -X "GET" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
    -H "Authorization: bearer $ZEN_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8'|grep "Create ACME Incident"|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then


  export PAYLOAD=$(echo "    {
  \"name\": \"🚀 DEMO - Create Incident ACME\",
  \"description\": \"Create Incident simulating a Datacenter Fan Failure leading to a VM failure and the Booking DB being unavailable.\",
  \"prerequisites\": \"\",
  \"parameters\": [],
  \"tags\": [],
  \"http\": {
    \"host\": \"https://$DEMOUI_ROUTE/injectRESTHeadless?app=ACME\",
    \"method\": \"GET\",
    \"headers\": \"{}\",
    \"ignoreCertErrors\": false
  }
  }")

  echo $PAYLOAD>/tmp/action.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/actions?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/action.json)
  echo $result
  rm /tmp/action.json

  export actionID=$(echo $result|jq -r ._actionId)

  echo "actionID: $actionID"

  export PAYLOAD=$(echo "{
          \"tags\": [],
          \"steps\": [
            {
              \"number\": 1,
              \"title\": \"Create Incident ACME\",
              \"automationId\": \"$actionID\",
              \"type\": \"automation\"
            }
          ],
          \"name\": \"🧨 Create ACME Incident\",
          \"description\": \"Create Incident simulating a Datacenter Fan Failure leading to a VM failure and the Booking DB being unavailable.\",
          \"parameters\": []
      }")
  echo $result
  echo $PAYLOAD>/tmp/runbook.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/runbook.json)


  rm /tmp/runbook.json
else 
  echo "Already exists"
fi 


export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export ROUTE=$(oc get route -n $AIOPS_NAMESPACE cpd -o jsonpath={.spec.host})
export DEMOUI_ROUTE=$(oc get route -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui -o jsonpath={.spec.host})
export DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 --decode)
export DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')



export result=$(curl -X "GET" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
    -H "Authorization: bearer $ZEN_TOKEN" \
    -H 'Content-Type: application/json; charset=utf-8'|grep "Create London Underground Incident"|wc -l|tr -d ' ')

if [[ $result == "0" ]]; then


  export PAYLOAD=$(echo "    {
  \"name\": \"🚀 DEMO - Create Incident London Underground\",
  \"description\": \"Create Incident simulating a Fire Alert at Mile End Tube Station.\",
  \"prerequisites\": \"\",
  \"parameters\": [],
  \"tags\": [],
  \"http\": {
    \"host\": \"https://$DEMOUI_ROUTE/injectRESTHeadless?app=tube\",
    \"method\": \"GET\",
    \"headers\": \"{}\",
    \"ignoreCertErrors\": false
  }
  }")

  echo $PAYLOAD>/tmp/action.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/actions?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/action.json)
  echo $result
  rm /tmp/action.json

  export actionID=$(echo $result|jq -r ._actionId)

  echo "actionID: $actionID"

  export PAYLOAD=$(echo "{
          \"tags\": [],
          \"steps\": [
            {
              \"number\": 1,
              \"title\": \"Create Incident London Underground\",
              \"automationId\": \"$actionID\",
              \"type\": \"automation\"
            }
          ],
          \"name\": \"🚇 Create London Underground Incident\",
          \"description\": \"Create Incident simulating a Fire Alert at Mile End Tube Station.\",
          \"parameters\": []
      }")
  echo $result
  echo $PAYLOAD>/tmp/runbook.json

  
  export result=$(curl -X "POST" -s -k "https://$ROUTE/aiops/api/story-manager/rba/v1/runbooks?publish=true" \
      -H "Authorization: bearer $ZEN_TOKEN" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d @/tmp/runbook.json)


  rm /tmp/runbook.json
else 
  echo "Already exists"
fi 




