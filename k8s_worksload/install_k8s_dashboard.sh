#!/bin/bash

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm repo update

helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --namespace kubernetes-dashboard --create-namespace

kubectl -n kubernetes-dashboard get svc

kubectl apply -f - <<EOF
### Dashbard admin-user SA ###
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---

### Dashbard admin-user Admin Cluster Role to SA ###
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

---

### Create a long-lived Bearer Token for ServiceAccount ###
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "admin-user"   
type: kubernetes.io/service-account-token  

---

EOF

kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy --address 0.0.0.0 8443:443 &

### Getting a long-lived Bearer Token for admin-user ServiceAccount ###
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d