


oc patch OAuth/cluster --type merge -p '{"spec": {"identityProviders": [{"ldap": {"attributes": {"email": [],"id": ["dn"],"name": ["cn"],"preferredUsername": ["cn"]},"bindDN": "cn=admin,dc=ibm,dc=com","bindPassword": {"name": "ldap-bind-password-demo"},"insecure": true,"url": "ldap://openldap.openldap:389/dc=ibm,dc=com?uid?sub?(objectclass=Person)"},"mappingMethod": "claim","name": "openldap","type": "LDAP"}]}}'

cat <<EOF | oc apply -f -
---
kind: Secret
apiVersion: v1
metadata:
  name: ldap-bind-password-demo
  namespace: openshift-config
data:
  bindPassword: UDRzc3cwcmQh
type: Opaque
---
kind: User
apiVersion: user.openshift.io/v1
metadata:
  name: demo
fullName: demo
identities:
  - 'openldap:dWlkPWRlbW8sb3U9UGVvcGxlLGRjPWlibSxkYz1jb20'
groups: null
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: demo
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
---
kind: User
apiVersion: user.openshift.io/v1
metadata:
  name: nik
fullName: nik
identities:
  - 'openldap:dWlkPW5payxvdT1QZW9wbGUsZGM9aWJtLGRjPWNvbQ'
groups: null
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin-nik
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: nik
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
EOF









