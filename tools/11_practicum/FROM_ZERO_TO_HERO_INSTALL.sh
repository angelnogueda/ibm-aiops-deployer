cat << EOF | oc apply -f -
apiVersion: v1                     
kind: Namespace
metadata:
  name: ibm-aiops-installer
---
kind: ServiceAccount
apiVersion: v1
metadata:
  name: ibm-aiops-installer-admin
  namespace: ibm-aiops-installer
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ibm-aiops-installer-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: ibm-aiops-installer-admin
    namespace: ibm-aiops-installer
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ibm-aiops-installer-default-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: default
    namespace: ibm-aiops-installer
---
apiVersion: batch/v1
kind: Job
metadata:
  name: aiops-easy-install-aimanager-practicum
  namespace: ibm-aiops-installer
spec:
  serviceAccountname: ibm-aiops-installer-admin
  template:
    spec:
      containers:
        - name: install
          image: quay.io/niklaushirt/ibm-aiops-tools:2.2
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              memory: "64Mi"
              cpu: "150m"
            limits:
              memory: "2024Mi"
              cpu: "1200m"
          command:
            - /bin/sh
            - -c
            - |
              #!/bin/bash
              #set -x

              echo "*****************************************************************************************************************************"
              echo " ✅ STARTING: INSTALL IBMAIOps with Demo Content"
              echo "*****************************************************************************************************************************"
              echo ""
              echo ""
              echo "------------------------------------------------------------------------------------------------------------------------------"
              echo " 📥 Clone Repo https://github.com/niklaushirt/ibm-aiops-deployer.git"
              git clone https://github.com/niklaushirt/ibm-aiops-deployer.git -b main

              
              cd ibm-aiops-deployer
              echo ""
              echo ""

              echo "------------------------------------------------------------------------------------------------------------------------------"
              echo " 🚀 Prepare Ansible"
              ansible-galaxy collection install community.kubernetes:1.2.1
              ansible-galaxy collection install kubernetes.core:2.2.3
              ansible-galaxy collection install cloud.common
              pip install openshift pyyaml kubernetes 
              echo ""
              echo ""

              echo "------------------------------------------------------------------------------------------------------------------------------"
              echo " 🚀 Starting Installation"
              ansible-playbook ./ansible/00_ibm-aiops-install.yaml -e "config_file_path=./configs/ibm-aiops-practicum.yaml"
              echo ""
              echo ""
              echo "*****************************************************************************************************************************"
              echo " ✅ DONE"
              echo "*****************************************************************************************************************************"

              while true
              do
                sleep 1000
              done

      restartPolicy: Never
  backoffLimit: 500
EOF