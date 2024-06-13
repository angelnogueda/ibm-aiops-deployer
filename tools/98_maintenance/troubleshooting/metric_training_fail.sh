oc delete pod  -n ibm-aiops --ignore-not-found $(oc get po -n ibm-aiops|grep spark|awk '{print$1}') --force --grace-period=0
oc delete pod  -n ibm-aiops --ignore-not-found $(oc get po -n ibm-aiops|grep metric|awk '{print$1}') --force --grace-period=0
