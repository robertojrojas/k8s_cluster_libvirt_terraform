#!/bin/bash

kubectl create deployment nginx-app --image=nginx --replicas=3

kubectl get deployment nginx-app -o wide

kubectl expose deployment nginx-app --type=NodePort --port=80

kubectl get svc nginx-app -o wide

kubectl describe svc nginx-app

NGINX_SVC_NODE_PORT=`kubectl get svc nginx-app -o jsonpath='{.spec.ports[0].nodePort}'`

for h in `k get nodes --no-headers | grep k8swr | awk '{print $1}'`
do
   echo -e "\n\n##### http://${h}:${NGINX_SVC_NODE_PORT} #####\n\n" 
   curl http://${h}:${NGINX_SVC_NODE_PORT}
done




