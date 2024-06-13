echo "*****************************************************************************************************************************"
echo " ✅ WIPE REMAINING AIOPS STUFF"
echo "*****************************************************************************************************************************"
echo ""
echo "  ⏳ INSTALLATION START TIMESTAMP: $(date)"
echo ""

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')


echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace sock-shop"
oc delete ns sock-shop &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace robot-shop"
oc delete ns robot-shop &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace awx"
oc delete ns awx &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete awx.ansible.com CustomResourceDefinition"
oc delete CustomResourceDefinition $(oc get CustomResourceDefinition| grep awx.ansible.com|awk '{print$1}') --ignore-not-found


echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace ibm-aiops-demo-ui"
oc delete ns ibm-aiops-demo-ui &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace ibm-aiops-tools"
oc delete ns ibm-aiops-tools &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace openldap"
oc delete ns openldap &
echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace ibm-aiops-installer"
oc delete ns ibm-aiops-installer &



oc delete ClusterRoleBinding admin-demo-user                   
oc delete ClusterRoleBinding admin-nik-user                    
oc delete ClusterRoleBinding awx-default                       
oc delete ClusterRoleBinding default-robotinfo1-admin          
oc delete ClusterRoleBinding default-robotinfo2-admin          
oc delete ClusterRoleBinding default-sockinfo1-admin           
oc delete ClusterRoleBinding default-sockinfo2-admin           
oc delete ClusterRoleBinding ibm-aiops-demo-ui-admin-crb       
oc delete ClusterRoleBinding ibm-aiops-installer-admin         
oc delete ClusterRoleBinding ibm-aiops-installer-default-admin 
oc delete ClusterRoleBinding robot-shop                        
oc delete ClusterRoleBinding test-admin    

echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete Namespace ibm-aiops-installer"
oc delete ns ibm-aiops-installer &




# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete namespacescopes"
# oc delete namespacescopes.operator.ibm.com -n ibm-common-services --all &
# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete operandbindinfos"
# oc delete operandbindinfos.operator.ibm.com -n ibm-common-services --all &

# oc patch namespacescope.operator.ibm.com -n ibm-common-services common-service  -p '{"metadata":{"finalizers":null}}' --type=merge          
# oc patch namespacescope.operator.ibm.com -n ibm-common-services nss-managedby-odlm  -p '{"metadata":{"finalizers":null}}' --type=merge          
# oc patch namespacescope.operator.ibm.com -n ibm-common-services nss-odlm-scope  -p '{"metadata":{"finalizers":null}}' --type=merge          
# oc patch namespacescope.operator.ibm.com -n ibm-common-services odlm-scope-managedby-odlm  -p '{"metadata":{"finalizers":null}}' --type=merge          
# oc patch operandbindinfo.operator.ibm.com -n ibm-common-services ibm-licensing-bindinfo  -p '{"metadata":{"finalizers":null}}' --type=merge          





# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete *.ibm.com CustomResourceDefinition"
# oc delete CustomResourceDefinition $(oc get CustomResourceDefinition| grep .ibm.com|awk '{print$1}') --ignore-not-found &
# sleep 5
# oc patch CustomResourceDefinition $(oc get CustomResourceDefinition| grep .ibm.com|awk '{print$1}')  -p '{"metadata":{"finalizers":null}}' --type=merge 


# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete Namespace ibm-common-services "
# oc delete ns ibm-common-services &
# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete Namespace ibm-aiops"
# oc delete ns ibm-aiops


# echo "------------------------------------------------------------------------------------------------------------------------------"
# echo " 🧻 Delete ClusterRoleBindings"
# oc delete ClusterRoleBinding ibm-aiops-demo-ui-admin-crb &                 
# oc delete ClusterRoleBinding awx-default &
# oc delete ClusterRoleBinding aimanager-api-platform &
# oc delete ClusterRoleBinding default-robotinfo1-admin &                        
# oc delete ClusterRoleBinding default-robotinfo2-admin &                        
# oc delete ClusterRoleBinding default-sockinfo1-admin &                         
# oc delete ClusterRoleBinding default-sockinfo2-admin &
# oc delete ClusterRoleBinding ibm-common-service-webhook-ibm-common-services &  
# oc delete ClusterRoleBinding ibm-zen-operator-serviceaccount &
# oc delete ClusterRoleBinding robot-shop &
# oc delete ClusterRoleBinding sre-tunnel-ibm-aiops-tunnel-cluster &             
# oc delete ClusterRoleBinding sre-tunnel-ibm-aiops-tunnel-cluster-api &


# oc patch ClusterRoleBinding ibm-aiops-demo-ui-admin-crb -p '{"metadata":{"finalizers":null}}' --type=merge                       
# oc patch ClusterRoleBinding awx-default -p '{"metadata":{"finalizers":null}}' --type=merge 
# oc patch ClusterRoleBinding aimanager-api-platform -p '{"metadata":{"finalizers":null}}' --type=merge 
# oc patch ClusterRoleBinding default-robotinfo1-admin -p '{"metadata":{"finalizers":null}}' --type=merge                         
# oc patch ClusterRoleBinding default-robotinfo2-admin -p '{"metadata":{"finalizers":null}}' --type=merge                         
# oc patch ClusterRoleBinding default-sockinfo1-admin -p '{"metadata":{"finalizers":null}}' --type=merge                          
# oc patch ClusterRoleBinding default-sockinfo2-admin -p '{"metadata":{"finalizers":null}}' --type=merge 
# oc patch ClusterRoleBinding ibm-common-service-webhook-ibm-common-services -p '{"metadata":{"finalizers":null}}' --type=merge   
# oc patch ClusterRoleBinding ibm-zen-operator-serviceaccount -p '{"metadata":{"finalizers":null}}' --type=merge 
# oc patch ClusterRoleBinding robot-shop -p '{"metadata":{"finalizers":null}}' --type=merge 
# oc patch ClusterRoleBinding sre-tunnel-ibm-aiops-tunnel-cluster -p '{"metadata":{"finalizers":null}}' --type=merge              
# oc patch ClusterRoleBinding sre-tunnel-ibm-aiops-tunnel-cluster-api -p '{"metadata":{"finalizers":null}}' --type=merge 


echo "------------------------------------------------------------------------------------------------------------------------------"
echo " 🧻 Delete IBM CatalogSource"
oc delete CatalogSource -n openshift-marketplace ibm-operator-catalog


oc delete ClusterRoleBinding ibm-aiops-installer-admin &
oc patch ClusterRoleBinding ibm-aiops-installer-admin -p '{"metadata":{"finalizers":null}}' --type=merge  

exit 1

oc delete CustomResourceDefinition $(oc get CustomResourceDefinition| grep .cert-manager.io|awk '{print$1}') --ignore-not-found
oc delete CustomResourceDefinition $(oc get CustomResourceDefinition| grep certmanager.k8s.io|awk '{print$1}') --ignore-not-found

oc get validatingwebhookconfigurations
oc get mutatingwebhookconfigurations

oc delete validatingwebhookconfigurations ibm-cs-ns-mapping-webhook-configuration
oc delete validatingwebhookconfigurations cert-manager-webhook


oc delete mutatingwebhookconfigurations cert-manager-webhook
oc delete mutatingwebhookconfigurations namespace-admission-config
#oc delete mutatingwebhookconfigurations ibm-operandrequest-webhook-configuration

oc get validatingwebhookconfigurations  -oyaml|grep common
oc get mutatingwebhookconfigurations  -oyaml|grep common
