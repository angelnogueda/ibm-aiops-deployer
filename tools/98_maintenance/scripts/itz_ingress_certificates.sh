
# CP4AIOPS

echo "✅ Seems that you're on Techzone IPI/UPI"  
echo "✅ Let's patch the certificates"  

mkdir backup
echo "Extracting signed cert"
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' letsencrypt-certs | base64 -d > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' letsencrypt-certs | base64 -d > cert.key
sed -e '1,33d' cert.crt > ca.crt

oc -n ibm-common-services patch managementingress default --type merge --patch '{"spec":{"ignoreRouteCert":true}}'
oc -n ibm-common-services get secret route-tls-secret -o yaml > backup/route-tls-secret.yaml 
echo "Common Service signed cert"

oc -n ibm-common-services delete certificates.v1alpha1.certmanager.k8s.io route-cert
oc -n ibm-common-services delete secret route-tls-secret
oc -n ibm-common-services create secret generic route-tls-secret   --from-file=ca.crt=./ca.crt --from-file=tls.crt=./cert.crt --from-file=tls.key=./cert.key
oc -n ibm-common-services delete secret ibmcloud-cluster-ca-cert
oc -n ibm-common-services delete pod -l app=auth-idp
oc -n ibm-common-services delete pod -l name=operand-deployment-lifecycle-manager

export podname=$(oc -n ibm-common-services get pods | grep '^management-ingress' | awk '{print$1}')
oc -n ibm-common-services delete pod $podname
echo "Wait for the management-ingress pod to come up"

sleep 60
echo "CPD signed cert"

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

oc get secret -n $AIOPS_NAMESPACE external-tls-secret -o yaml > backup/external-tls-secret.yaml
oc create secret generic -n $AIOPS_NAMESPACE external-tls-secret --from-file=ca.crt=ca.crt --from-file=cert.crt=cert.crt --from-file=cert.key=cert.key --dry-run=client -o yaml | oc apply -f -
REPLICAS=$(oc get pods -n $AIOPS_NAMESPACE |grep ibm-nginx|wc -l |xargs)
oc scale Deployment/ibm-nginx --replicas=0 -n $AIOPS_NAMESPACE
sleep 10
oc scale Deployment/ibm-nginx --replicas=${REPLICAS} -n $AIOPS_NAMESPACE





# TURBONOMIC

echo "✅ Seems that you're on Techzone IPI/UPI"  
echo "✅ Let's patch the certificates"  

echo "Extracting signed cert"
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' letsencrypt-certs | base64 -d > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' letsencrypt-certs | base64 -d > cert.key

oc create secret tls -n turbonomic nginx-ingressgateway-certs --cert=cert.crt --key=cert.key --dry-run=client -o yaml | oc apply -f -


REPLICAS=$(oc get pods -n turbonomic |grep nginx|wc -l |xargs)
oc scale Deployment/nginx --replicas=0 -n turbonomic
sleep 10
oc scale Deployment/nginx --replicas=${REPLICAS} -n turbonomic


