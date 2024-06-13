
INSTALL_POD=$(oc get po -n ibm-aiops-installer|grep install|awk '{print$1}')
oc logs -n ibm-aiops-installer -f $INSTALL_POD