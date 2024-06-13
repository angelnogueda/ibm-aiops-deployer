
INSTALL_POD=$(oc get po -n ibm-aiops-installer|grep install|awk '{print$1}')
FILE_PATH="/ibm-aiops-deployer/install_IBMAIOps.log"

oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_IBMAIOps.log ./install_IBMAIOps.log 
oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_IBMAIOpsDemoContent.log ./install_IBMAIOpsDemoContent.log 
oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_EventManager.log ./install_EventManager.log 
oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_InfrastructureManagement.log ./install_InfrastructureManagement.log 
oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_ELK.log ./install_ELK.log 
oc cp -n ibm-aiops-installer ${INSTALL_POD}:/ibm-aiops-deployer/install_Turbonomic.log ./install_Turbonomic.log 

oc logs -n ibm-aiops-installer -f $INSTALL_POD > install.log
