
echo "*************************************************************************************************************************************"
echo " 🧻 Cleaning Up"
echo "*************************************************************************************************************************************"

# export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
# oc delete job -n $AIOPS_NAMESPACE-installer load-log-indexes --ignore-not-found
# oc delete job -n $AIOPS_NAMESPACE-installer load-metric-cassandra --ignore-not-found
# oc delete job -n $AIOPS_NAMESPACE-installer load-snow-indexes --ignore-not-found
echo "*************************************************************************************************************************************"
echo "*************************************************************************************************************************************"
echo ""
echo ""
echo ""
echo ""
echo ""


oc delete ConsoleNotification --all>/dev/null 2>/dev/null
export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
export appURL=$(oc get routes -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui  -o jsonpath="{['spec']['host']}")|| true
export DEMO_PWD=$(oc get cm -n $AIOPS_NAMESPACE-demo-ui ibm-aiops-demo-ui-config -o jsonpath='{.data.TOKEN}')
cat <<EOF | oc apply -f -
apiVersion: console.openshift.io/v1
kind: ConsoleNotification
metadata:
    name: ibm-aiops-notification-main
spec:
    backgroundColor: '#009a00'
    color: '#fff'
    link:
        href: "https://$appURL"
        text: DemoUI
    location: BannerTop
    text: "✅ IBMAIOPS is installed in this cluster. 🚀 Access the DemoUI with Password '$DEMO_PWD' here:"
EOF

echo "*****************************************************************************************************************************"
echo " ✅ INSTALLATION DONE"
echo "*****************************************************************************************************************************"
